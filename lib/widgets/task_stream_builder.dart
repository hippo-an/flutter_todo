import 'package:flutter/material.dart';
import 'package:todo_todo/models/task_model.dart';
import 'package:todo_todo/widgets/task_list_section.dart';

class TaskStreamBuilder extends StatelessWidget {
  const TaskStreamBuilder({
    super.key,
    required this.stream,
  });

  final Stream<List<TaskModel>> stream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TaskModel>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong. Please reload.'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.connectionState == ConnectionState.active &&
            snapshot.hasData) {
          if (snapshot.data!.isEmpty) {
            return const SizedBox.shrink();
          } else {
            return TaskListSection(tasks: snapshot.data!);
          }
        }

        return const Center(
          child: Text(
              'Something went wrong.\nPlease waiting or reloading an app.'),
        );
      },
    );
  }
}
