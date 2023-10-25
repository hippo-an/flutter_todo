import 'package:flutter/material.dart';
import 'package:todo_todo/widgets/category_bar.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: const Column(
        children: [
          CategoryBar(),
        ],
      ),
    );
  }
}
