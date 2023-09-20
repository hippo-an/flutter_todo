import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/components/task_list_screen/task_list_item.dart';
import 'package:todo_todo/models/category_model.dart';
import 'package:todo_todo/models/task_model.dart';
import 'package:todo_todo/provider/task_list_provider.dart';

class TaskListBox extends StatelessWidget {
  const TaskListBox({super.key, this.selectedCategory});

  final CategoryModel? selectedCategory;

  @override
  Widget build(BuildContext context) {
    final taskListProvider = Provider.of<TaskListProvider>(context);
    final tasks = taskListProvider.tasks(selectedCategory);
    return Expanded(
      child: ReorderableListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final TaskModel task = tasks[index];
          return TaskListItem(
            key: ValueKey(task.taskId),
            task: task,
          );
        },
        onReorder: (int oldIndex, int newIndex) {
          if (oldIndex == newIndex) {
            return;
          }
          int offset = oldIndex < newIndex ? 1 : 0;
          // categoryProvider.reorderCategory(oldIndex, newIndex - offset);
        },
      ),
    );
  }
}
