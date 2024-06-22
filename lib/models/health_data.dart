import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'chart_data.dart';

class HealthDataProvider extends ChangeNotifier {
  final String url =
      'https://healthguard-wokwi-default-rtdb.firebaseio.com/HealthData.json';
  Map<String, dynamic> healthData = {};
  bool isLoading = true;
  String errorMessage = '';
  Timer? _timer;
  Random random = Random();

  bool heartRateNotified = false;
  bool bodyTemperatureNotified = false;
  bool oxygenLevelNotified = false;
  bool breathRateNotified = false;
  bool notificationsEnabled = true;

  List<ChartData> bodyTemperatureData = [];
  List<ChartData> breathRateData = [];
  List<ChartData> heartRateData = [];
  List<ChartData> oxygenLevelData = [];

  final BuildContext context;

  HealthDataProvider(this.context) {
    fetchHealthData();
    _timer =
        Timer.periodic(Duration(seconds: 10), (Timer t) => fetchHealthData());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchHealthData() async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        healthData = json.decode(response.body) ?? {};
        bodyTemperatureData = generateChartData(healthData['bodyTemperature']);
        breathRateData = generateChartData(healthData['breathRate']);
        heartRateData = generateHeartRateData(healthData['heartRate']);
        oxygenLevelData = generateChartData(healthData['oxygenLevel']);
        isLoading = false;
        checkForAnomalies();
        notifyListeners();
      } else {
        errorMessage = 'Failed to load data: ${response.statusCode}';
        isLoading = false;
        notifyListeners();
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage = 'An error occurred: $e';
      isLoading = false;
      notifyListeners();
      print('An error occurred: $e');
    }
  }

  List<ChartData> generateChartData(dynamic value) {
    List<ChartData> data = [];
    double currentValue = value != null ? value.toDouble() : 0.0;

    for (int i = 0; i < 10; i++) {
      double variation = (random.nextDouble() - 0.5) * 2;
      data.add(ChartData(i.toDouble(), currentValue + variation));
    }

    return data;
  }

  List<ChartData> generateHeartRateData(dynamic value) {
    List<ChartData> data = [];
    double currentValue = value != null ? value.toDouble() : 70.0;

    for (int i = 0; i < 10; i++) {
      double angle = (i / 10) * 2 * pi;
      double sinusoidalValue = currentValue + 10 * sin(angle);
      data.add(ChartData(i.toDouble(), sinusoidalValue));
    }

    return data;
  }

  void checkForAnomalies() {
    if (healthData.isNotEmpty) {
      if (healthData['heartRate'] != null &&
          (healthData['heartRate'] < 60 || healthData['heartRate'] > 100)) {
        if (!heartRateNotified) {
          showNotification('Heart Rate',
              'Heart rate is out of normal range: ${healthData['heartRate']} bpm');
          heartRateNotified = true;
        }
      } else {
        heartRateNotified = false;
      }

      if (healthData['bodyTemperature'] != null &&
          (healthData['bodyTemperature'] < 32 ||
              healthData['bodyTemperature'] > 40)) {
        if (!bodyTemperatureNotified) {
          showNotification('Body Temperature',
              'Body temperature is out of normal range: ${healthData['bodyTemperature']} °C');
          bodyTemperatureNotified = true;
        }
      } else {
        bodyTemperatureNotified = false;
      }

      if (healthData['oxygenLevel'] != null && healthData['oxygenLevel'] < 90) {
        if (!oxygenLevelNotified) {
          showNotification('Oxygen Level',
              'Oxygen level is below normal: ${healthData['oxygenLevel']}%');
          oxygenLevelNotified = true;
        }
      } else {
        oxygenLevelNotified = false;
      }

      if (healthData['breathRate'] != null &&
          (healthData['breathRate'] < 12 || healthData['breathRate'] > 18)) {
        if (!breathRateNotified) {
          showNotification('Breath Rate',
              'Breath rate is out of normal range: ${healthData['breathRate']} bpm');
          breathRateNotified = true;
        }
      } else {
        breathRateNotified = false;
      }
    }
  }

  void showNotification(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
