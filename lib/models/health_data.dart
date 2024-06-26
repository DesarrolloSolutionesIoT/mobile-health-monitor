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

  List<ChartData> bodyTemperatureData = [];
  List<ChartData> breathRateData = [];
  List<ChartData> heartRateData = [];
  List<ChartData> oxygenLevelData = [];

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
    if (data.length < 9) {
      // Inicializar la lista con el valor actual si aún no tiene 9 elementos
      data.add(ChartData(data.length.toDouble(), value));
    } else {
      // Desplazar todos los puntos un lugar hacia la izquierda
      for (int i = 0; i < data.length - 1; i++) {
        data[i] = ChartData(i.toDouble(), data[i + 1].y);
      }
      // Añadir el nuevo valor en la última posición (posición 8)
      data[data.length - 1] = ChartData((data.length - 1).toDouble(), value);
    }
    notifyListeners();
  }
}
