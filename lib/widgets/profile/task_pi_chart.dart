import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/colors.dart';
import 'package:todo_todo/controller/category_controller.dart';

class TaskPiChart extends StatefulWidget {
  const TaskPiChart({
    super.key,
    required this.categoryAndCount,
  });

  final Map<String, int> categoryAndCount;

  @override
  State<TaskPiChart> createState() => _TaskPiChartState();
}

class _TaskPiChartState extends State<TaskPiChart> {
  double opacity = 0.1;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: PieChart(
          PieChartData(
            pieTouchData: PieTouchData(
              touchCallback: (FlTouchEvent event, pieTouchResponse) {},
            ),
            borderData: FlBorderData(
              show: false,
            ),
            sectionsSpace: 10,
            centerSpaceRadius: 30,
            sections: widget.categoryAndCount.isEmpty
                ? [
                    PieChartSectionData(
                      color: kColorScheme.withOpacity(0.5),
                      radius: 30.0,
                      titleStyle: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(color: Colors.black, blurRadius: 2),
                        ],
                      ),
                    ),
                  ]
                : widget.categoryAndCount.entries.map(
                    (entry) {
                      final category = Provider.of<CategoryController>(context, listen: false)
                          .findNullableSeenCategory(entry.key)!;

                      return PieChartSectionData(
                        color: category.color,
                        showTitle: true,
                        title: '${entry.value}',
                        radius: 30.0,
                        titleStyle: const TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(color: Colors.black, blurRadius: 2),
                          ],
                        ),
                      );
                    },
                  ).toList(),
          ),
        ),
      ),
    );
  }
}
