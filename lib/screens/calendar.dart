import 'package:flutter/material.dart';
import 'package:todo_todo/models/datas.dart';
import 'package:todo_todo/widget/task.dart';

class CalendarScreen extends StatelessWidget {
  // final tasks = const <Task>[];
  final tasks = dummyTasks;
  CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calendar',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (ctx, idx) {
            return tasks[idx];
          }),
    );
  }
}
