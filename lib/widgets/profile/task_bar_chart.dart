import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/colors.dart';
import 'package:todo_todo/controller/category_controller.dart';
import 'package:todo_todo/controller/task_chart_controller.dart';

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
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: FutureBuilder(
          future: Provider.of<TaskChartController>(context, listen: false)
              .fetchWeeklyCompletionTasks(
            from: from,
            to: to,
            categoryIds: Provider.of<CategoryController>(context, listen: false)
                .seenCategoryIds,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Something went wrong.'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasData) {
              final Map<DateTime, int> tasks = snapshot.data!;
              double max = calcMaxCount(tasks);

              return _BarChart(
                tasks: tasks,
                max: max,
              );
            }

            return const Center(
              child: Text('Something went wrong.'),
            );
          },
        ),
      ),
    );
  }

  double calcMaxCount(Map<DateTime, int> tasks) {
    int max = 0;

    for (final count in tasks.values) {
      if (count > max) {
        max = count;
      }
    }
    return max.toDouble();
  }
}

class _BarChart extends StatelessWidget {
  const _BarChart({
    super.key,
    required this.tasks,
    required this.max,
  });

  final Map<DateTime, int> tasks;
  final double max;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Stack(
      children: [
        BarChart(
          BarChartData(
            minY: 0,
            maxY: max == 0 ? 8 : max,
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            barGroups: tasks.entries
                .map(
                  (e) => BarChartGroupData(
                    x: e.key.weekday - 1,
                    barRods: [
                      BarChartRodData(
                        gradient: LinearGradient(
                          colors: [color, kColorScheme],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        toY: e.value.toDouble(),
                        // color: color,
                        width: 14,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(3),
                          topRight: Radius.circular(3),
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
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
                        style: const TextStyle(
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
        if (max == 0)
          const Center(
            child: Text('Empty in this week..'),
          ),
      ],
    );
  }
}
