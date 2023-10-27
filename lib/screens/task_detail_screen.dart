import 'package:flutter/material.dart';
import 'package:todo_todo/models/task_model.dart';
import 'package:todo_todo/widgets/task_detail.dart';

class TaskDetailScreen extends StatelessWidget {
  static const routeName = '/task_detail';

  const TaskDetailScreen({
    super.key,
    required this.task,
  });

  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: TaskDetail(
          task: task,
          // category: _category!,
        ),
      ),
    );
  }
}
