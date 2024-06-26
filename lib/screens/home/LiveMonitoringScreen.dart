import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'HealthDataProvider.dart';
import '../../models/chart_data.dart';
import 'ChartWidget.dart';

class LiveMonitoringScreen extends StatelessWidget {
  final int iotDataId;
  final int patientId;
  LiveMonitoringScreen({required this.iotDataId, required this.patientId});

  @override
  Widget build(BuildContext context) {
    print('Initializing LiveMonitoringScreen with iotDataId: $iotDataId');
    return ChangeNotifierProvider(
      create: (context) => HealthDataProvider(iotDataId: iotDataId,patientId: patientId ),
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

class DataCard extends StatelessWidget {
  final String title;
  final List<ChartData> data;
  final dynamic currentValue;
  final double minY;
  final double maxY;

  DataCard({
    required this.title,
    required this.data,
    required this.currentValue,
    required this.minY,
    required this.maxY,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(title),
            subtitle: Text('Valor Actual: $currentValue'),
          ),
          Container(
            height: 200,
            child: ChartWidget(data: data, minY: minY, maxY: maxY),
          ),
        ],
      ),
    );
  }
}
