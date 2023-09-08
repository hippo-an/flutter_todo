import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/components/custom_floating_action_button.dart';
import 'package:todo_todo/components/main_calendar_container.dart';
import 'package:todo_todo/components/todo_list_container.dart';
import 'package:todo_todo/screens/task_add_screen.dart';

class TodoCalendarScreen extends StatelessWidget {
  const TodoCalendarScreen({super.key});

  static const routeName = 'calendar';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomFloatingActionButton(),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: const Column(
          children: [
            MainCalendarContainer(),
            SizedBox(height: 10),
            TodoListContainer(),
          ],
        ),
      ),
    );
  }
}
