import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TaskPiChart extends StatefulWidget {
  const TaskPiChart({super.key});

  @override
  State<TaskPiChart> createState() => _TaskPiChartState();
}

class _TaskPiChartState extends State<TaskPiChart> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: PieChart(
          PieChartData(
            pieTouchData: PieTouchData(
              touchCallback: (FlTouchEvent event, pieTouchResponse) {
                // setState(() {
                //   if (!event.isInterestedForInteractions ||
                //       pieTouchResponse == null ||
                //       pieTouchResponse.touchedSection == null) {
                //     touchedIndex = -1;
                //     return;
                //   }
                //   touchedIndex = pieTouchResponse
                //       .touchedSection!.touchedSectionIndex;
                // });
              },
            ),
            borderData: FlBorderData(
              show: false,
            ),
            sectionsSpace: 0,
            centerSpaceRadius: 40,
            sections: List.generate(4, (i) {
              switch (i) {
                case 0:
                  return PieChartSectionData(
                    color: Colors.blue,
                    value: 40,
                    title: '40%',
                    radius: 30.0,
                    titleStyle: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: Colors.black, blurRadius: 2)],
                    ),
                  );
                case 1:
                  return PieChartSectionData(
                    color: Colors.yellow,
                    value: 30,
                    title: '30%',
                    radius: 30.0,
                    titleStyle: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: Colors.black, blurRadius: 2)],
                    ),
                  );
                case 2:
                  return PieChartSectionData(
                    color: Colors.purple,
                    value: 15,
                    title: '15%',
                    radius: 30.0,
                    titleStyle: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: Colors.black, blurRadius: 2)],
                    ),
                  );
                case 3:
                  return PieChartSectionData(
                    color: Colors.green,
                    value: 15,
                    title: '15%',
                    radius: 30.0,
                    titleStyle: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: Colors.black, blurRadius: 2)],
                    ),
                  );
                default:
                  throw Error();
              }
            }),
          ),
        ),
      ),
    );
  }
}
