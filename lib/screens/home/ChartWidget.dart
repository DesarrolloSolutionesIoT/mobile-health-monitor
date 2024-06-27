import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/chart_data.dart';

class ChartWidget extends StatelessWidget {
  final List<ChartData> data;
  final double minY;
  final double maxY;
  final double thresholdMin;
  final double thresholdMax;

  ChartWidget({
    required this.data,
    required this.minY,
    required this.maxY,
    required this.thresholdMin,
    required this.thresholdMax,
  });

  List<LineChartBarData> _createLineChartBarData(List<ChartData> data) {
    List<LineChartBarData> lines = [];

    for (int i = 0; i < data.length - 1; i++) {
      Color colorData = (data[i].y < thresholdMin || data[i].y > thresholdMax) ? Colors.red : Colors.blue;

      lines.add(LineChartBarData(
        spots: [
          FlSpot(data[i].x, data[i].y),
          FlSpot(data[i + 1].x, data[i + 1].y),
        ],
        isCurved: true,
        color: colorData,
        barWidth: 2,
        belowBarData: BarAreaData(show: false),
        dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, barData, index) {
            Color dotColor = (spot.y < thresholdMin || spot.y > thresholdMax) ? Colors.red : Colors.blue;
            return FlDotCirclePainter(
              radius: 4,
              color: dotColor,
              strokeWidth: 2,
              strokeColor: Colors.black,
            );
          },
        ),
      ));
    }

    return lines;
  }

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
            ..._createLineChartBarData(data),
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