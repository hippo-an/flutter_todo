import 'package:flutter/material.dart';
import 'package:todo_todo/utils.dart';
import 'package:todo_todo/widgets/profile/base_card.dart';
import 'package:todo_todo/widgets/profile/task_bar_chart.dart';

class TaskBarSection extends StatefulWidget {
  const TaskBarSection({super.key});

  @override
  State<TaskBarSection> createState() => _TaskBarSectionState();
}

class _TaskBarSectionState extends State<TaskBarSection> {
  final DateTime _now = DateTime.now().toUtc();
  DateTime _date = DateTime.now().toUtc();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final from = mostRecentMonday(_date);
    final to = toSunday(_date);
    bool showRightArrow = true;

    if (_now.isBefore(to)) {
      showRightArrow = false;
    }

    return BaseCard(
      width: size.width,
      height: size.height * 0.3,
      color: Theme.of(context).colorScheme.onBackground,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  const Text(
                    'Completion of Daily Tasks',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _date = lastWeek(_date);
                          });
                        },
                        child: const Icon(
                          Icons.arrow_left,
                          size: 18,
                        ),
                      ),
                      Text(
                        '${slashFormatDate(from)}~${slashFormatDate(to)}',
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      if (showRightArrow)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _date = nextWeek(_date);
                            });
                          },
                          child: const Icon(
                            Icons.arrow_right,
                            size: 18,
                          ),
                        ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            TaskBarChart(
              from: from,
              to: to,
            ),
          ],
        ),
      ),
    );
  }
}
