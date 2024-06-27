import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/chart_data.dart';

class ChartWidget extends StatelessWidget {
  final List<ChartData> data;
  final double minY;
  final double maxY;
  final double thresholdMin;
  final double thresholdMax;

  ChartWidget({required this.data, required this.minY, required this.maxY, required this.thresholdMin, required this.thresholdMax});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false), // Hide the background grid
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: (maxY - minY) / 5,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(0),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
          ),
          minX: 0,
          maxX: 8,
          minY: minY,
          maxY: maxY,
          lineBarsData: [
            LineChartBarData(
              spots: data.take(9).map((point) => FlSpot(point.x, point.y)).toList(),
              isCurved: true,
              color: Colors.blue,
              barWidth: 2,
              belowBarData: BarAreaData(show: false),
              dotData: FlDotData(show: true),
            ),
            LineChartBarData(
              spots: [
                FlSpot(0, thresholdMax),
                FlSpot(8, thresholdMax),
              ],
              isCurved: false,
              color: Colors.transparent,
              barWidth: 0,
              belowBarData: BarAreaData(
                show: true,
                color: Colors.blueGrey.withOpacity(0.2),
                cutOffY: thresholdMin,
                applyCutOffY: true,
              ),
              dotData: FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
