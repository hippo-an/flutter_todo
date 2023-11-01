import 'package:flutter/material.dart';
import 'package:todo_todo/widgets/calendar/task_bar_section.dart';
import 'package:todo_todo/widgets/profile/base_card.dart';
import 'package:todo_todo/widgets/profile/next_days_section.dart';
import 'package:todo_todo/widgets/profile/profile_bar.dart';
import 'package:todo_todo/widgets/profile/task_count_bar.dart';
import 'package:todo_todo/widgets/profile/task_over_view_text.dart';
import 'package:todo_todo/widgets/profile/task_pi_chart.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          const ProfileBar(),
          const SizedBox(height: 10),
          const TaskOverViewText(),
          const SizedBox(height: 4),
          const TaskCountBar(),
          const TaskBarSection(),
          const NextDaysSection(),
          BaseCard(
            width: size.width,
            height: size.height * 0.4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Pending Tasks in Categories',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.arrow_drop_down,
                            size: 18,
                          ),
                          Text(
                            'In 7 Days',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: Row(
                      children: [
                        TaskPiChart(),
                        Expanded(
                          child: Center(
                            child: ListView.builder(
                              itemCount: 5,
                              padding: EdgeInsets.all(2),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Center(
                                  child: Text('• ${index}'),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
