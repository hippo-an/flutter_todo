import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/controller/category_controller.dart';
import 'package:todo_todo/widgets/calendar_task_box.dart';
import 'package:todo_todo/widgets/calendar_task_list_for_paging.dart';
import 'package:todo_todo/widgets/main_calendar.dart';

class TaskCalendarScreen extends StatelessWidget {
  const TaskCalendarScreen({super.key});

  static const routeName = '/calendar';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(),
      child: const Column(
        children: [
          MainCalendar(),
          SizedBox(height: 10),
          CalendarTaskBox(),
        ],
      ),
    );
  }
}
