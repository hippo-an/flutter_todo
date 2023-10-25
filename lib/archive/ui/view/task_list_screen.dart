import 'package:flutter/material.dart';
import 'package:todo_todo/archive/ui/shared/custom_floating_action_button.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  static const routeName = 'tasks';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      floatingActionButton: CustomFloatingActionButton(),
      body: Column(
        children: [
          // CategoryBar(),
          // SizedBox(height: 10),
          // TaskListBox(),
        ],
      ),
    );
  }
}
