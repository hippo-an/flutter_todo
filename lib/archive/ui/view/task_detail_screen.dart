import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/archive/locator.dart';
import 'package:todo_todo/archive/core/models/task_model.dart';
import 'package:todo_todo/archive/core/view_models/category_view_model.dart';
import 'package:todo_todo/archive/ui/widgets/task_list_screen/task_detail.dart';

class TaskDetailScreen extends StatelessWidget {
  static const routeName = 'task_detail';

  const TaskDetailScreen({
    super.key,
    required this.task,
  });

  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: TaskDetail(
        task: task,
        category: locator<CategoryViewModel>()
            .findCategory(task.categoryId),
      ),
    );
  }
}
