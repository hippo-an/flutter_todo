import 'package:flutter/material.dart';
import 'package:todo_todo/components/calendar_screen/calendar_task_list_box.dart';
import 'package:todo_todo/components/calendar_screen/main_calendar.dart';
import 'package:todo_todo/components/common/custom_floating_action_button.dart';

class TodoCalendarScreen extends StatelessWidget {
  const TodoCalendarScreen({super.key});

  static const routeName = 'calendar';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      floatingActionButton: CustomFloatingActionButton(),
      body: Column(
        children: [
          MainCalendar(),
          SizedBox(height: 10),
          CalendarTaskListBox(),
        ],
      ),
    );
  }
}
