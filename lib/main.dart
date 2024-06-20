import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  runApp(HealthMonitorApp());
}

class HealthMonitorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Monitor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: HealthMonitorHomePage(),
    );
  }
}

class HealthMonitorHomePage extends StatefulWidget {
  @override
  _HealthMonitorHomePageState createState() => _HealthMonitorHomePageState();
}

class _HealthMonitorHomePageState extends State<HealthMonitorHomePage> {
  final String url =
      'https://healthguard-wokwi-default-rtdb.firebaseio.com/HealthData.json';
  Map<String, dynamic> healthData = {};
  bool isLoading = true;
  String errorMessage = '';
  Timer? _timer;
  List<ChartData> bodyTemperatureData = [];
  List<ChartData> breathRateData = [];
  List<ChartData> heartRateData = [];
  List<ChartData> oxygenLevelData = [];
  Random random = Random();

  @override
  void initState() {
    super.initState();
    fetchHealthData();
    _timer =
        Timer.periodic(Duration(seconds: 1), (Timer t) => updateChartData());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchHealthData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          healthData = json.decode(response.body) ?? {};
          bodyTemperatureData =
              generateChartData(healthData['bodyTemperature']);
          breathRateData = generateChartData(healthData['breathRate']);
          heartRateData = generateHeartRateData(healthData['heartRate']);
          oxygenLevelData = generateChartData(healthData['oxygenLevel']);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load data: ${response.statusCode}';
          isLoading = false;
        });
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
        isLoading = false;
      });
      print('An error occurred: $e');
    }
  }

  List<ChartData> generateChartData(dynamic value) {
    List<ChartData> data = [];
    double currentValue = value != null ? value.toDouble() : 0.0;

    for (int i = 0; i < 10; i++) {
      // Generate a random variation around the current value
      double variation = (random.nextDouble() - 0.5) * 2;
      data.add(ChartData(i.toDouble(), currentValue + variation));
    }

    return data;
  }

  List<ChartData> generateHeartRateData(dynamic value) {
    List<ChartData> data = [];
    double currentValue = value != null
        ? value.toDouble()
        : 70.0; // Default heart rate if value is null

    for (int i = 0; i < 10; i++) {
      // Generate a sinusoidal variation around the current value
      double angle = (i / 10) * 2 * pi;
      double sinusoidalValue = currentValue + 10 * sin(angle);
      data.add(ChartData(i.toDouble(), sinusoidalValue));
    }

    return data;
  }

  void updateChartData() {
    setState(() {
      updateDataList(bodyTemperatureData, healthData['bodyTemperature']);
      updateDataList(breathRateData, healthData['breathRate']);
      updateHeartRateData(heartRateData, healthData['heartRate']);
      updateDataList(oxygenLevelData, healthData['oxygenLevel']);
    });
  }

  void updateDataList(List<ChartData> dataList, dynamic value) {
    if (dataList.isNotEmpty) {
      dataList.removeAt(0);
      double currentValue = value != null ? value.toDouble() : dataList.last.y;
      double variation = (random.nextDouble() - 0.5) * 2;
      dataList.add(ChartData(dataList.last.x + 1, currentValue + variation));
    }
  }

  void updateHeartRateData(List<ChartData> dataList, dynamic value) {
    if (dataList.isNotEmpty) {
      dataList.removeAt(0);
      double currentValue = value != null
          ? value.toDouble()
          : 70.0; // Default heart rate if value is null
      double angle = ((dataList.last.x + 1) / 10) * 2 * pi;
      double sinusoidalValue = currentValue + 10 * sin(angle);
      dataList.add(ChartData(dataList.last.x + 1, sinusoidalValue));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Monitor'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        buildHealthCard(
                            'Body Temperature',
                            healthData['bodyTemperature'],
                            '°C',
                            bodyTemperatureData),
                        buildHealthCard('Breath Rate', healthData['breathRate'],
                            'bpm', breathRateData),
                        buildHealthCard('Heart Rate', healthData['heartRate'],
                            'bpm', heartRateData),
                        buildHealthCard('Oxygen Level',
                            healthData['oxygenLevel'], '%', oxygenLevelData),
                        Text('Last Updated: ${healthData['time'] ?? 'N/A'}'),
                      ],
                    ),
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchHealthData,
        child: Icon(Icons.refresh),
      ),
    );
  }

  Card buildHealthCard(
      String title, dynamic value, String unit, List<ChartData> data) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$title: ${value ?? 'N/A'} $unit',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 150,
              child: SfCartesianChart(
                primaryXAxis: NumericAxis(isVisible: true),
                primaryYAxis: NumericAxis(isVisible: true),
                series: <ChartSeries>[
                  LineSeries<ChartData, double>(
                    dataSource: data,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                    animationDuration: 0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  final double x;
  final double y;

  ChartData(this.x, this.y);
}
