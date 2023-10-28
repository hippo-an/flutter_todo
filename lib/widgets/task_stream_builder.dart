import 'package:flutter/material.dart';
import 'package:todo_todo/models/task_model.dart';
import 'package:todo_todo/widgets/complete_task_list_section.dart';
import 'package:todo_todo/widgets/not_complete_task_list_section.dart';

class TaskStreamBuilder extends StatelessWidget {
  const TaskStreamBuilder({
    super.key,
    required this.stream,
    this.isComplete = false,
  });

  final Stream<List<TaskModel>> stream;
  final bool isComplete;

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
            if (!isComplete) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: const Center(
                  child: Text('Task is empty!'),
                ),
              );
            }
            return const SizedBox.shrink();
          } else if (!isComplete) {
            return NotCompleteTaskListSection(tasks: snapshot.data!);
          } else {
            return CompleteTaskListSection(
              tasks: snapshot.data!,
            );
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
