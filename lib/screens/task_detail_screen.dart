import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/components/task_detail.dart';
import 'package:todo_todo/provider/selected_task_provider.dart';

class TaskDetailScreen extends StatelessWidget {
  static const routeName = 'task_detail';

  const TaskDetailScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var selectedTaskProvider = Provider.of<SelectedTaskProvider>(context);
    return SafeArea(
      child: TaskDetail(
        task: selectedTaskProvider.selectedTask!,
      ),
    );
  }
}
