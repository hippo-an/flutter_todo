import 'package:flutter/material.dart';
import 'package:todo_todo/components/calendar_screen/main_calendar_container.dart';
import 'package:todo_todo/components/common/custom_floating_action_button.dart';

class TodoCalendarScreen extends StatelessWidget {
  const TodoCalendarScreen({super.key});

  static const routeName = 'calendar';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const CustomFloatingActionButton(),
      body: Container(
        child: const Column(
          children: [
            MainCalendarContainer(),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
