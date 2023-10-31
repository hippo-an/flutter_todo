import 'package:flutter/material.dart';
import 'package:todo_todo/models/task_model.dart';
import 'package:todo_todo/widgets/task_detail.dart';

class TaskDetailStream extends StatelessWidget {
  const TaskDetailStream({
    super.key,
    required this.task,
  });

  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    // return StreamBuilder<TaskModel>(
    //   stream: locator<TaskRepository>().task(task.taskId),
    //   builder: (context, snapshot) {
    //     if (snapshot.hasError) {
    //       return const Center(
    //         child: Text('Something went wrong. Please retry.'),
    //       );
    //     }
    //
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return const Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     }
    //
    //     if (snapshot.hasData) {
    //       return TaskDetail(task: snapshot.data!);
    //     }
    //
    //     return const Center(
    //       child: Text('Something went wrong.\nPlease waiting or retry an app.'),
    //     );
    //   },
    // );
    return TaskDetail(task: task);
  }
}
