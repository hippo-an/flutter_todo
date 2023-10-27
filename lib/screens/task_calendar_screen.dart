import 'package:flutter/material.dart';
import 'package:todo_todo/widgets/main_calendar.dart';

class TaskCalendarScreen extends StatelessWidget {
  const TaskCalendarScreen({super.key});

  static const routeName = '/calendar';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(),
      child: Column(
        children: [
          MainCalendar(),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
