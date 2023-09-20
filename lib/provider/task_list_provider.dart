import 'dart:io';

import 'package:flutter/material.dart';
import 'package:todo_todo/consts/tools.dart';
import 'package:todo_todo/models/category_model.dart';
import 'package:todo_todo/models/sub_task_model.dart';
import 'package:todo_todo/models/task_model.dart';

class TaskListProvider extends ChangeNotifier {
  final List<TaskModel> _tasks = [];

  List<TaskModel> tasks(CategoryModel? categoryModel) {
    if (categoryModel == null) {
      final copiedList = [..._tasks];
      copiedList.sort((a, b) {
        return 0;
      });
      return copiedList;
    }

    final categorizedTask =
        _tasks.where((task) => task.categoryModel == categoryModel).toList();
    categorizedTask.sort((a, b) {
      return 1;
    });
    return categorizedTask;
  }

  void createTask(
    String name, {
    DateTime? dueDate,
    CategoryModel? categoryModel,
    List<SubTaskModel> subTasks = const [],
  }) {
    final now = DateTime.now();
    final task = TaskModel(
        taskId: uuid.generate(),
        taskName: name,
        categoryModel: categoryModel,
        dueDate: dueDate,
        createdAt: now,
        updatedAt: now,
        subTasks: subTasks);

    _tasks.add(task);

    notifyListeners();
  }

  TaskModel? updateTask({
    required TaskModel task,
    String? taskName,
    bool? isDone,
    String? note,
    CategoryModel? categoryModel,
    DateTime? dueDate,
    List<SubTaskModel>? subTasks,
    File? attachment,
  }) {
    final index = _tasks.indexOf(task);
    if (index < -1) {
      return null;
    }
    final updatedTask = task.copyWith(
        taskName: taskName,
        isDone: isDone,
        note: note,
        categoryModel: categoryModel,
        dueDate: dueDate,
        subTasks: subTasks,
        attachment: attachment,
        updatedAt: DateTime.now());

    _tasks
      ..removeAt(index)
      ..insert(index, updatedTask);

    notifyListeners();

    return updatedTask;
  }
}
