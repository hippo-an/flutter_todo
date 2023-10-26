import 'package:flutter/material.dart';
import 'package:todo_todo/common/firestore_exception.dart';
import 'package:todo_todo/controller/category_controller.dart';
import 'package:todo_todo/models/category_model.dart';
import 'package:todo_todo/models/sub_task_model.dart';
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
    required List<SubTaskModel> subtasks,
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
      await _fetchTask(task.taskId);
      notifyListeners();
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
    required List<SubTaskModel> subtasks,
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
      subTasks: subtasks,
    );
  }
}
