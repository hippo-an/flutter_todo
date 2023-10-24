import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/archive/core/view_models/task_view_model.dart';
import 'package:todo_todo/archive/ui/shared/task_list_item.dart';

class DeletedTaskScreen extends StatelessWidget {
  const DeletedTaskScreen({super.key});

  static String routeName = 'deleted-tasks';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deleted Tasks'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Consumer<TaskViewModel>(
          builder:
              (BuildContext context, TaskViewModel provider, Widget? child) {
            final deletedTasks = provider.deletedTask;
            return ListView.builder(
              itemCount: deletedTasks.length,
              itemBuilder: (context, index) => TaskListItem(
                task: deletedTasks[index],
                taskItemState: TaskItemState.deleted,
              ),
            );
          },
        ),
      ),
    );
  }
}
