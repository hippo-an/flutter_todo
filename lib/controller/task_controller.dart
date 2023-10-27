import 'package:flutter/material.dart';
import 'package:todo_todo/common/firestore_exception.dart';
import 'package:todo_todo/controller/category_controller.dart';
import 'package:todo_todo/models/category_model.dart';
import 'package:todo_todo/models/subtask_model.dart';
import 'package:todo_todo/models/task_model.dart';
import 'package:todo_todo/repository/auth_repository.dart';
import 'package:todo_todo/repository/task_repository.dart';
import 'package:todo_todo/utils.dart';

class TaskController extends ChangeNotifier {
  final TaskRepository _taskRepository;
  final AuthRepository _authRepository;
  final CategoryController _categoryController;

  TaskController({
    required TaskRepository taskRepository,
    required AuthRepository authRepository,
    required CategoryController categoryController,
  })  : _taskRepository = taskRepository,
        _authRepository = authRepository,
        _categoryController = categoryController;

  List<TaskModel> _tasks = [];

  Future<bool> createTask(
    BuildContext context, {
    required String taskName,
    DateTime? dueDate,
    CategoryModel? category,
    required List<SubtaskModel> subtasks,
  }) async {
    final categoryModel = (category ?? _categoryController.defaultCategory);

    final task = _createTask(
      taskName: taskName,
      categoryId: categoryModel.categoryId,
      dueDate: dueDate,
      subtasks: subtasks,
    );

    try {
      await _taskRepository.createTask(task: task);
      await _categoryController.taskCountIncrease(context,
          categoryId: categoryModel.categoryId, value: 1);
      return true;
    } on FirestoreException catch (e) {
      showSnackBar(context, e.toString());
      return false;
    } finally {
      // await _fetchTask(task.taskId);
      // notifyListeners();
    }
  }

  Future<void> _fetchTask(String taskId) async {
    try {
      final TaskModel? task = await _taskRepository.fetchTask(taskId);

      if (task != null) {
        _tasks.add(task);
      }

      // _categories.sort(
      //   (a, b) {
      //     if (a.isDefault) {
      //       return 0;
      //     } else if (b.isDefault) {
      //       return 1;
      //     } else {
      //       return a.createdAt.compareTo(b.createdAt);
      //     }
      //   },
      // );
    } catch (e) {}
  }

  TaskModel _createTask({
    required String taskName,
    required String categoryId,
    required DateTime? dueDate,
    required List<SubtaskModel> subtasks,
  }) {
    final now = DateTime.now();
    return TaskModel(
      taskId: uuid.generate(),
      taskName: taskName,
      categoryId: categoryId,
      uid: _authRepository.currentUser.uid,
      dueDate: dueDate,
      createdAt: now,
      updatedAt: now,
      subtasks: subtasks,
    );
  }

  Future<bool> updateTaskToDone(BuildContext context,
      {required String taskId, required bool done}) async {
    try {
      await _taskRepository.updateTaskToDone(taskId: taskId, isDone: done);
      return true;
    } on FirestoreException catch (e) {
      showSnackBar(context, e.toString());
      return false;
    }
  }

  Future<bool> deleteTask(
    BuildContext context, {
    required String taskId,
    required String categoryId,
  }) async {
    try {
      await _categoryController.taskCountIncrease(
        context,
        categoryId: categoryId,
        value: -1,
      );
      await _taskRepository.deleteTask(taskId: taskId);
      return true;
    } on FirestoreException catch (e) {
      showSnackBar(context, e.toString());
      return false;
    }
  }

  Future<bool> startStateChange(
    BuildContext context, {
    required String taskId,
    required bool value,
  }) async {
    try {
      await _taskRepository.startStateChange(taskId: taskId, value: value);
      return true;
    } on FirestoreException catch (e) {
      showSnackBar(context, e.toString());
      return false;
    }
  }

  Future<bool> updateDueDate(
    BuildContext context, {
    required String taskId,
    DateTime? dueDate,
  }) async {
    try {
      await _taskRepository.updateDueDate(
        taskId: taskId,
        dueDate: dueDate,
      );
      return true;
    } on FirestoreException catch (e) {
      showSnackBar(context, e.toString());
      return false;
    }
  }

  Future<bool> updateCategory(
    BuildContext context, {
    required String taskId,
    required String categoryId,
    required String oldCategoryId,
  }) async {
    try {
      await _taskRepository.updateCategory(
        taskId: taskId,
        categoryId: categoryId,
      );

      await _categoryController.taskCountIncrease(context,
          categoryId: categoryId, value: 1);
      await _categoryController.taskCountIncrease(context,
          categoryId: oldCategoryId, value: -1);
      return true;
    } on FirestoreException catch (e) {
      showSnackBar(context, e.toString());
      return false;
    }
  }

  Future<bool> updateTaskName(
    BuildContext context, {
    required String taskId,
    required String taskName,
  }) async {
    try {
      await _taskRepository.updateTaskName(
        taskId: taskId,
        taskName: taskName,
      );
      return true;
    } on FirestoreException catch (e) {
      showSnackBar(context, e.toString());
      return false;
    }
  }

  Future<bool> updateNote(
    BuildContext context, {
    required String taskId,
    required String note,
  }) async {
    try {
      await _taskRepository.updateNote(
        taskId: taskId,
        note: note,
      );
      return true;
    } on FirestoreException catch (e) {
      showSnackBar(context, e.toString());
      return false;
    }
  }

  Future<bool> updateSubtasks(BuildContext context,
      {required String taskId, required List<SubtaskModel> subtasks}) async {
    try {
      await _taskRepository.updateSubtask(
        taskId: taskId,
        subtasks: subtasks,
      );
      return true;
    } on FirestoreException catch (e) {
      showSnackBar(context, e.toString());
      return false;
    }
  }
}
