import 'package:flutter/material.dart';
import 'package:todo_todo/common/firestore_exception.dart';
import 'package:todo_todo/models/task_model.dart';
import 'package:todo_todo/repository/auth_repository.dart';
import 'package:todo_todo/repository/task_repository.dart';
import 'package:todo_todo/utils.dart';

class TaskChartController extends ChangeNotifier {
  final TaskRepository _taskRepository;
  final AuthRepository _authRepository;

  TaskChartController({
    required TaskRepository taskRepository,
    required AuthRepository authRepository,
  })  : _taskRepository = taskRepository,
        _authRepository = authRepository;

  Future<Map<DateTime, int>> fetchWeeklyCompletionTasks({
    required DateTime from,
    required DateTime to,
    required List<String> categoryIds,
  }) async {
    try {
      final tasks = await _taskRepository.fetchWeeklyCompletionTasks(
        uid: _authRepository.currentUser.uid,
        from: from,
        to: to,
        categoryIds: categoryIds,
      );

      final Map<DateTime, int> ret = {};

      for (int offset = 0; offset < 7; offset++) {
        ret.putIfAbsent(
            DateTime.utc(from.year, from.month, from.day + offset), () => 0);
      }

      for (final task in tasks) {
        ret.update(
          task.completedDate!,
          (value) => value + 1,
          ifAbsent: () => 0,
        );
      }

      return ret;
    } on FirestoreException catch (e) {
      print(e.message.toString());
      final Map<DateTime, int> ret = {};

      for (int offset = 0; offset < 7; offset++) {
        ret.putIfAbsent(
            DateTime(from.year, from.month, from.day + offset), () => 1);
      }

      return ret;
    }
  }

  Future<List<TaskModel>> fetchNextNDaysToBeDoneTasks({
    required int days,
    required DateTime from,
    required List<String> categoryIds,
  }) async {
    try {
      return await _taskRepository.fetchNextNDaysToBeDoneTasks(
        uid: _authRepository.currentUser.uid,
        from: from,
        to: dateAdd(from, days),
        categoryIds: categoryIds,
      );
    } on FirestoreException catch (e) {
      print(e.message.toString());
      return [];
    }
  }

  Future<Map<String, int>> fetchPendingTasks({
    required int days,
    required DateTime to,
    required List<String> categoryIds,
  }) async {
    try {
      final tasks = await _taskRepository.fetchNextNDaysToBeDoneTasks(
        uid: _authRepository.currentUser.uid,
        from: dateAdd(to, days),
        to: to,
        categoryIds: categoryIds,
      );

      final Map<String, int> ret = {};

      for (final task in tasks) {
        ret.update(
          task.categoryId,
          (value) => value + 1,
          ifAbsent: () => 1,
        );
      }

      return ret;
    } on FirestoreException catch (e) {
      print(e.message.toString());
      return {};
    }
  }
}
