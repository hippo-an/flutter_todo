import 'package:flutter/material.dart';
import 'package:todo_todo/consts/tools.dart';
import 'package:todo_todo/models/category_model.dart';
import 'package:todo_todo/models/sub_task_model.dart';
import 'package:todo_todo/models/task_model.dart';

class TaskListProvider extends ChangeNotifier {
  final List<TaskModel> _tasks = [];

  List<TaskModel> tasks(CategoryModel? categoryModel) {
    if (categoryModel == null) {
      return [..._tasks];
    }

    return _tasks.where((task) => task.categoryModel == categoryModel).toList();
  }

  void createTask(String name, {
    DateTime? dueDate,
    CategoryModel? categoryModel,
    List<SubTaskModel> subTasks = const[],
  }) {
    final now = DateTime.now();
    final task = TaskModel(
        taskId: uuid.generate(),
        taskName: name,
        categoryModel: categoryModel,
        dueDate: dueDate,
        createdAt: now,
        updatedAt: now,
        subTasks: subTasks
    );

    _tasks.add(task);

    notifyListeners();
  }

  void updateTick(String taskId) {
  }
}
