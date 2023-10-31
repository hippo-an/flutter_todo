import 'package:flutter/material.dart';
import 'package:todo_todo/widgets/category_bar.dart';
import 'package:todo_todo/widgets/task_list_widget.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CategoryBar(),
        SizedBox(height: 10),
        TaskListWidget(),
      ],
    );
  }
}
