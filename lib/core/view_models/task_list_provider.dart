import 'dart:io';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_todo/common/tools.dart';
import 'package:todo_todo/core/models/category_model.dart';
import 'package:todo_todo/core/models/sub_task_model.dart';
import 'package:todo_todo/core/models/task_model.dart';
import 'package:todo_todo/core/services/task_repository.dart';

class TaskListProvider extends ChangeNotifier {
  final TaskRepository taskRepository;

  TaskListProvider(
    CategoryModel? selectedCategory,
    this.taskRepository,
  ) : _selectedCategory = selectedCategory;
  CategoryModel? _selectedCategory;

  List<TaskModel> get filteredTask {
    if (_selectedCategory!.isDefault) {
      final copiedList = taskRepository.tasks.where((task) => !task.isDeleted).toList();

      // TODO: Task 정렬
      copiedList.sort((a, b) {
        return 0;
      });

      return copiedList;
    }

    final categorizedTask = taskRepository.tasks
        .where((task) =>
            !task.isDeleted && task.categoryId == _selectedCategory!.categoryId)
        .toList();

    // TODO: Task 정렬
    categorizedTask.sort((a, b) {
      return 0;
    });

    return categorizedTask;
  }

  List<TaskModel> get staredTask {
    final copiedList =
    taskRepository.tasks.where((task) => !task.isDeleted && task.stared).toList();

    // TODO: Task 정렬
    copiedList.sort((a, b) {
      return 0;
    });

    return copiedList;
  }

  List<TaskModel> get deletedTask {
    final copiedList = taskRepository.tasks.where((task) => task.isDeleted).toList();

    // TODO: Task 정렬
    copiedList.sort((a, b) {
      return 0;
    });

    return copiedList;
  }

  List<TaskModel> calendarList(DateTime selectedDate) {
    final copiedList = taskRepository.tasks
        .where(
            (task) => !task.isDeleted && isSameDay(selectedDate, task.dueDate))
        .toList();

    // TODO: Task 정렬
    copiedList.sort((a, b) {
      return 0;
    });

    return copiedList;
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
    required CategoryModel categoryModel,
    List<SubTaskModel> subTasks = const [],
  }) {
    final now = DateTime.now();
    final task = TaskModel(
        taskId: uuid.generate(),
        taskName: name,
        categoryId: categoryModel.categoryId,
        dueDate: dueDate,
        createdAt: now,
        updatedAt: now,
        subTasks: subTasks);

    taskRepository.add(task);

    notifyListeners();
  }

  TaskModel? updateTask({
    required TaskModel task,
    String? taskName,
    bool? isDone,
    bool? isDeleted,
    bool? stared,
    DateTime? completedDate,
    String? note,
    String? categoryId,
    DateTime? dueDate,
    DateTime? deletedAt,
    List<SubTaskModel>? subTasks,
    File? attachment,
  }) {
    final index = taskRepository.index(task);
    if (index < -1) {
      return null;
    }
    final updatedTask = task.copyWith(
        taskName: taskName,
        isDone: isDone,
        isDeleted: isDeleted,
        stared: stared,
        completedDate: () => completedDate,
        note: note,
        categoryId: categoryId,
        dueDate: () => dueDate,
        deletedAt: () => deletedAt,
        subTasks: subTasks,
        attachment: attachment,
        updatedAt: DateTime.now());

    taskRepository.replace(index, updatedTask);

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
    taskRepository.tasks.removeWhere((task) => task.categoryId == category.categoryId);
    notifyListeners();
  }

  // void updateCategory(CategoryModel updatedCategory) {
  //   final updatedTasks = _tasks.map((task) {
  //     if (task.categoryModel == updatedCategory) {
  //       return task.copyWith(categoryModel: updatedCategory);
  //     }
  //     return task;
  //   }).toList();
  //   _tasks.clear();
  //   _tasks.addAll(updatedTasks);
  //   notifyListeners();
  // }

  void deleteTask({required TaskModel task}) {
    taskRepository.remove(task);
    notifyListeners();
  }
}
