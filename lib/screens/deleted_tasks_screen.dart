import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/components/common/task_list_item.dart';
import 'package:todo_todo/provider/task_list_provider.dart';

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
        child: Consumer<TaskListProvider>(
          builder:
              (BuildContext context, TaskListProvider provider, Widget? child) {
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
