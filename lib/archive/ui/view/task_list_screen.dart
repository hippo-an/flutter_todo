import 'package:flutter/material.dart';
import 'package:todo_todo/archive/ui/shared/custom_floating_action_button.dart';
import 'package:todo_todo/archive/ui/widgets/task_list_screen/task_list_box.dart';
import 'package:todo_todo/archive/ui/widgets/task_list_screen/top_bar.dart';

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
