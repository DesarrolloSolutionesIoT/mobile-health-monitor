import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/DataCard.dart';
import '../../models/chart_data.dart';
import '../../models/health_data.dart';
import 'ChartWidget.dart';

class LiveMonitoringScreen extends StatelessWidget {
  final Map<String, dynamic> iotData;

  LiveMonitoringScreen({required this.iotData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HealthDataProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Monitoreo en Vivo'),
        ),
        body: Consumer<HealthDataProvider>(
          builder: (context, healthDataProvider, child) {
            if (healthDataProvider.isLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (healthDataProvider.errorMessage.isNotEmpty) {
              return Center(child: Text(healthDataProvider.errorMessage));
            } else {
              return ListView(
                children: <Widget>[
                  DataCard(
                    title: 'Frecuencia Cardiaca',
                    data: healthDataProvider.heartRateData,
                    currentValue: healthDataProvider.healthData['heartRate'] ?? 'N/A',
                    minY: 0,
                    maxY: 200,
                  ),
                  DataCard(
                    title: 'Temperatura Corporal',
                    data: healthDataProvider.bodyTemperatureData,
                    currentValue: healthDataProvider.healthData['temperature'] ?? 'N/A',
                    minY: 0,
                    maxY: 100,
                  ),
                  DataCard(
                    title: 'Nivel de Oxígeno',
                    data: healthDataProvider.oxygenLevelData,
                    currentValue: healthDataProvider.healthData['oximeter'] ?? 'N/A',
                    minY: 0,
                    maxY: 100,
                  ),
                  DataCard(
                    title: 'Frecuencia Respiratoria',
                    data: healthDataProvider.breathRateData,
                    currentValue: healthDataProvider.healthData['respiratoryRate'] ?? 'N/A',
                    minY: 0,
                    maxY: 50,
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}