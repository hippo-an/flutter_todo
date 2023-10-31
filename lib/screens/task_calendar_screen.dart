import 'package:flutter/material.dart';
import 'package:todo_todo/widgets/calendar/calendar_task_box.dart';
import 'package:todo_todo/widgets/main_calendar.dart';

class TaskCalendarScreen extends StatefulWidget {
  const TaskCalendarScreen({super.key});

  static const routeName = '/calendar';

  @override
  State<TaskCalendarScreen> createState() => _TaskCalendarScreenState();
}

class _TaskCalendarScreenState extends State<TaskCalendarScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        MainCalendar(),
        SizedBox(height: 10),
        CalendarTaskBox(),
      ],
    );
  }
}
