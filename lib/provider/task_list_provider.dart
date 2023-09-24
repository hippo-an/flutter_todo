import 'dart:io';

import 'package:flutter/material.dart';
import 'package:todo_todo/consts/enums.dart';
import 'package:todo_todo/consts/tools.dart';
import 'package:todo_todo/models/category_model.dart';
import 'package:todo_todo/models/sub_task_model.dart';
import 'package:todo_todo/models/task_model.dart';

class TaskListProvider extends ChangeNotifier {
  TaskListProvider(CategoryModel? selectedCategory)
      : _selectedCategory = selectedCategory;

  final List<TaskModel> _tasks = [];
  CategoryModel? _selectedCategory;

  List<TaskModel> get filteredTask {
    if (_selectedCategory == null) {
      final copiedList = _tasks
          .where((task) =>
              task.categoryModel == null ||
              task.categoryModel!.categoryState == CategoryState.activated)
          .toList();

      // TODO: Task 정렬
      copiedList.sort((a, b) {
        return 0;
      });

      return copiedList;
    }

    final categorizedTask = _tasks
        .where((task) =>
            task.categoryModel == _selectedCategory &&
            task.categoryModel!.categoryState == CategoryState.activated)
        .toList();

    // TODO: Task 정렬
    categorizedTask.sort((a, b) {
      return 0;
    });

    return categorizedTask;
  }

  // Future loadTodos() {
  //   _isLoading = true;
  //   notifyListeners();
  //
  //   return repository.loadTodos().then((loadedTodos) {
  //     _todos.addAll(loadedTodos.map(Todo.fromEntity));
  //     _isLoading = false;
  //     notifyListeners();
  //   }).catchError((err) {
  //     _isLoading = false;
  //     notifyListeners();
  //   });
  // }

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

  TaskListProvider? initializeSelectedCategory(
      CategoryModel? selectedCategory) {
    _selectedCategory = selectedCategory;
    notifyListeners();
    return this;
  }

  void deleteTaskByCategory(CategoryModel category) {
    _tasks.removeWhere((task) => task.categoryModel == category);
    notifyListeners();
  }

  void updateCategory(CategoryModel updatedCategory) {
    final updatedTasks = _tasks.map((task) {
      if (task.categoryModel == updatedCategory) {
        return task.copyWith(categoryModel: updatedCategory);
      }
      return task;
    }).toList();
    _tasks.clear();
    _tasks.addAll(updatedTasks);
    notifyListeners();
  }
}
