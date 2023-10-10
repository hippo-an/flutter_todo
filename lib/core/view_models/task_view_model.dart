import 'dart:io';

import 'package:table_calendar/table_calendar.dart';
import 'package:todo_todo/common/tools.dart';
import 'package:todo_todo/core/models/category_model.dart';
import 'package:todo_todo/core/models/sub_task_model.dart';
import 'package:todo_todo/core/models/task_model.dart';
import 'package:todo_todo/core/services/repository/task_repository.dart';
import 'package:todo_todo/core/view_models/base_model.dart';
import 'package:todo_todo/core/view_models/category_view_model.dart';
import 'package:todo_todo/locator.dart';

class TaskViewModel extends BaseModel {
  final CategoryViewModel _categoryViewModel;
  final TaskRepository _taskRepository;
  final List<TaskModel> _tasks = [];

  TaskViewModel()
      : _taskRepository = locator<TaskRepository>(),
        _categoryViewModel = locator<CategoryViewModel>();

  Future<void> fetchTasks() async {
    setState(ViewState.busy);
    _tasks.clear();
    final tasks =
        await _taskRepository.fetchTasks(_categoryViewModel.selectedCategory);
    _tasks.addAll(tasks);
    setState(ViewState.idle);
  }

  List<TaskModel> get filteredTask {
    if (_categoryViewModel.selectedCategory.isDefault) {
      final copiedList =
          _taskRepository.tasks.where((task) => !task.isDeleted).toList();

      // TODO: Task 정렬
      copiedList.sort((a, b) {
        return 0;
      });

      return copiedList;
    }

    final categorizedTask = _taskRepository.tasks
        .where((task) =>
            !task.isDeleted &&
            task.categoryId == _categoryViewModel.selectedCategory.categoryId)
        .toList();

    // TODO: Task 정렬
    categorizedTask.sort((a, b) {
      return 0;
    });

    return categorizedTask;
  }

  List<TaskModel> get staredTask {
    final copiedList = _taskRepository.tasks
        .where((task) => !task.isDeleted && task.stared)
        .toList();

    // TODO: Task 정렬
    copiedList.sort((a, b) {
      return 0;
    });

    return copiedList;
  }

  List<TaskModel> get deletedTask {
    final copiedList =
        _taskRepository.tasks.where((task) => task.isDeleted).toList();

    // TODO: Task 정렬
    copiedList.sort((a, b) {
      return 0;
    });

    return copiedList;
  }

  List<TaskModel> calendarList(DateTime selectedDate) {
    final copiedList = _taskRepository.tasks
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

    _taskRepository.add(task);

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
    final index = _taskRepository.index(task);
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

    _taskRepository.replace(index, updatedTask);

    notifyListeners();

    return updatedTask;
  }

  Future<void> deleteTaskByCategory(CategoryModel category) async {
    await _taskRepository.deleteTasksByCategory(category);
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
    _taskRepository.remove(task);
    notifyListeners();
  }
}
