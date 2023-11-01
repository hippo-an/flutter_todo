import 'package:flutter/material.dart';
import 'package:todo_todo/widgets/calendar/task_bar_section.dart';
import 'package:todo_todo/widgets/profile/base_card.dart';
import 'package:todo_todo/widgets/profile/next_days_section.dart';
import 'package:todo_todo/widgets/profile/pending_tasks_section.dart';
import 'package:todo_todo/widgets/profile/profile_bar.dart';
import 'package:todo_todo/widgets/profile/task_count_bar.dart';
import 'package:todo_todo/widgets/profile/task_over_view_text.dart';
import 'package:todo_todo/widgets/profile/task_pi_chart.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          ProfileBar(),
          SizedBox(height: 10),
          TaskOverViewText(),
          SizedBox(height: 4),
          TaskCountBar(),
          TaskBarSection(),
          NextDaysSection(),
          PendingTasksSection(),
        ],
      ),
    );
  }
}
