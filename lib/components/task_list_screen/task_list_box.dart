import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/components/task_list_screen/task_list_item.dart';
import 'package:todo_todo/models/task_model.dart';
import 'package:todo_todo/provider/task_list_provider.dart';

class TaskListBox extends StatelessWidget {
  const TaskListBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskListProvider>(
      builder: (BuildContext context, taskListProvider, Widget? child) {
        var filteredTask = taskListProvider.filteredTask;
        return Expanded(
          child: ListView.builder(
            itemCount: filteredTask.length,
            itemBuilder: (context, index) {
              final TaskModel task = filteredTask[index];
              return TaskListItem(
                key: ValueKey(task.taskId),
                task: task,
              );
            },
            // onReorder: (int oldIndex, int newIndex) {
            //   if (oldIndex == newIndex) {
            //     return;
            //   }
            //   int offset = oldIndex < newIndex ? 1 : 0;
            //   // categoryProvider.reorderCategory(oldIndex, newIndex - offset);
            // },
          ),
        );
      },
    );
  }
}
