import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/chart_data.dart';

class ChartWidget extends StatelessWidget {
  final List<ChartData> data;
  final double minY;
  final double maxY;

  ChartWidget({required this.data, required this.minY, required this.maxY});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false), // Ocultar títulos inferiores
          ),
        ),
        borderData: FlBorderData(show: true),
        minX: 0,
        maxX: 9, // Ajustar para mostrar las 10 posiciones
        minY: minY,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: data.map((point) => FlSpot(point.x, point.y)).toList(),
            isCurved: true,
            color: Colors.blue,
            barWidth: 2,
            belowBarData: BarAreaData(show: false),
            dotData: FlDotData(show: true),
          ),
        ],
      ),
    );
  }
}