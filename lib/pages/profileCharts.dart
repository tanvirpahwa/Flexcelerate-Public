import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../logic/dailyStats.dart';

class CaloriesBurnedChart extends StatelessWidget {
  final List<DailyStatistics> data;

  CaloriesBurnedChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 200.0,
        width: 500.0,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                horizontalInterval: 100
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 35)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 19,
                  interval: 1,
                  getTitlesWidget: (value, title) {
                    switch (value.toInt()) {
                      case 0:
                        return Text('Su');
                      case 1:
                        return Text('M');
                      case 2:
                        return Text('Tu');
                      case 3:
                        return Text('W');
                      case 4:
                        return Text('Th');
                      case 5:
                        return Text('F');
                      case 6:
                        return Text('Sa');
                      default:
                        return SizedBox.shrink(); // Return an empty widget if no title should be displayed
                    }
                  }
              )),
            ),
            borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.greenAccent, width: 1)
            ),
            minX: 0,
            maxX: data.length.toDouble() - 1,
            minY: 0,
            maxY: data.map((stats) => stats.caloriesBurned).reduce((a, b) => a > b ? a : b),
            lineBarsData: [
              LineChartBarData(
                spots: List.generate(data.length, (index) => FlSpot(index.toDouble(), data[index].caloriesBurned)),
                isCurved: true,
                color: Colors.greenAccent,
                preventCurveOverShooting: true,
                dotData: FlDotData(show: true),
                belowBarData: BarAreaData(show: false),
              ),
            ],
          ),
        )
    );
  }
}

class StepsTakenChart extends StatelessWidget {
  final List<DailyStatistics> data;

  StepsTakenChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 200.0,
        width: 500.0,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                horizontalInterval: 1000
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false,)),
              bottomTitles: AxisTitles(sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 19,
                  interval: 1,
                  getTitlesWidget: (value, title) {
                    switch (value.toInt()) {
                      case 0:
                        return Text('Su');
                      case 1:
                        return Text('M');
                      case 2:
                        return Text('Tu');
                      case 3:
                        return Text('W');
                      case 4:
                        return Text('Th');
                      case 5:
                        return Text('F');
                      case 6:
                        return Text('Sa');
                      default:
                        return SizedBox.shrink(); // Return an empty widget if no title should be displayed
                    }
                  }
              )),
            ),
            borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.greenAccent, width: 1)
            ),
            minX: 0,
            maxX: data.length.toDouble() - 1,
            minY: 0,
            maxY: data.map((stats) => stats.stepsTaken).reduce((a, b) => a > b ? a : b),
            lineBarsData: [
              LineChartBarData(
                spots: List.generate(data.length, (index) => FlSpot(index.toDouble(), data[index].stepsTaken.toDouble())),
                isCurved: true,
                color: Colors.greenAccent,
                preventCurveOverShooting: true,
                dotData: FlDotData(show: true),
                belowBarData: BarAreaData(show: false),
              ),
            ],
          ),
        )
    );
  }
}