import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:todo_todo/colors.dart';

class TaskBarChart extends StatelessWidget {
  const TaskBarChart({
    super.key,
    required this.from,
    required this.to,
  });

  final DateTime from;
  final DateTime to;

  @override
  Widget build(BuildContext context) {
    double max = 8;
    final color = Theme.of(context).colorScheme.primary;
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
                  ...List.generate(
                    7,
                    (index) {
                      return _taskBarData(
                        x: index,
                        y: index % 2 == 0 ? index.toDouble() : 0.0,
                        color: color,
                      );
                    },
                  ),
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
