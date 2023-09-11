import 'package:flutter/material.dart';
import 'package:todo_todo/components/category_bar_menu_anchor.dart';
import 'package:todo_todo/components/custom_floating_action_button.dart';
import 'package:todo_todo/components/task_list_screen/category_list_bar.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  static const routeName = 'tasks';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const CustomFloatingActionButton(),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.04,
        width: double.infinity,
        child: const Row(
          children: [
            CategoryListBar(),
            CategoryBarMenuAnchor(),
          ],
        ),
      ),
    );
  }
}
