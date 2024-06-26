import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../models/chart_data.dart';

class HealthDataProvider extends ChangeNotifier {
  final String url = 'http://localhost:8080/api/iotdata/2';
  Map<String, dynamic> healthData = {};
  bool isLoading = true;
  String errorMessage = '';
  Timer? _timer;

  List<ChartData> bodyTemperatureData = List.generate(10, (index) => ChartData(index.toDouble(), 0));
  List<ChartData> breathRateData = List.generate(10, (index) => ChartData(index.toDouble(), 0));
  List<ChartData> heartRateData = List.generate(10, (index) => ChartData(index.toDouble(), 0));
  List<ChartData> oxygenLevelData = List.generate(10, (index) => ChartData(index.toDouble(), 0));

  HealthDataProvider() {
    fetchHealthData();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => fetchHealthData());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchHealthData() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        healthData = json.decode(response.body);
        updateChartData(bodyTemperatureData, healthData['temperature'].toDouble());
        updateChartData(breathRateData, healthData['respiratoryRate'].toDouble());
        updateChartData(heartRateData, healthData['heartRate'].toDouble());
        updateChartData(oxygenLevelData, healthData['oximeter'].toDouble());
        isLoading = false;
        notifyListeners();
      } else {
        errorMessage = 'Failed to load data: ${response.statusCode}';
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      errorMessage = 'An error occurred: $e';
      isLoading = false;
      notifyListeners();
    }
  }

  void updateChartData(List<ChartData> data, double value) {
    // Desplazar todos los puntos un lugar hacia la izquierda
    for (int i = 0; i < 9; i++) {
      data[i] = ChartData(i.toDouble(), data[i + 1].y);
    }
    // Añadir el nuevo valor en la posición 8
    data[8] = ChartData(8.0, value);
    // Mantener la posición 9 vacía
    data[9] = ChartData(9.0, 0.0);
    notifyListeners();
  }
}
