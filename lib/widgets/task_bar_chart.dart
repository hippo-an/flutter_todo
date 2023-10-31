import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:todo_todo/colors.dart';

class TaskBarChart extends StatelessWidget {
  const TaskBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    double max = 8;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Stack(
          children: [
            BarChart(
              BarChartData(
                minY: 0,
                maxY: max,
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: [
                  _taskBarData(
                      x: 0, color: Theme.of(context).colorScheme.primary),
                  _taskBarData(
                      x: 1, color: Theme.of(context).colorScheme.primary),
                  _taskBarData(
                      x: 2,
                      y: max,
                      color: Theme.of(context).colorScheme.primary),
                  _taskBarData(
                      x: 3, color: Theme.of(context).colorScheme.primary),
                  _taskBarData(
                      x: 4, color: Theme.of(context).colorScheme.primary),
                  _taskBarData(
                      x: 5, y: 3, color: Theme.of(context).colorScheme.primary),
                  _taskBarData(
                      x: 6, color: Theme.of(context).colorScheme.primary),
                ],
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      reservedSize: 32,
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        String text = '';
                        switch (value.toInt()) {
                          case 0:
                            text = 'Mon';
                          case 1:
                            text = 'Tue';
                          case 2:
                            text = 'Wed';
                          case 3:
                            text = 'Thu';
                          case 4:
                            text = 'Fri';
                          case 5:
                            text = 'Sat';
                          case 6:
                            text = 'Sun';
                          default:
                            return Container();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 14),
                          child: Text(
                            text,
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.all(2),
                          child: Text('${value.toInt()}'),
                        );
                      },
                      showTitles: true,
                      interval: 2,
                      reservedSize: 32,
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Text('Overlay'),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _taskBarData({
    int x = 0,
    double y = 0,
    required Color color,
    double width = 14,
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          gradient: LinearGradient(
            colors: [color, kColorScheme],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          toY: y,
          // color: color,
          width: width,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(3),
            topRight: Radius.circular(3),
          ),
        ),
      ],
    );
  }
}
