
import 'package:todo_todo/core/models/task_model.dart';

class TaskRepository {
  final List<TaskModel> _tasks = [];

  List<TaskModel> get tasks => [..._tasks];

  void add(TaskModel task) {
    _tasks.add(task);
  }

  int index(TaskModel task) {
    return _tasks.indexOf(task);
  }

  void replace(int index, TaskModel updatedTask) {
    _tasks
      ..removeAt(index)
      ..insert(index, updatedTask);
  }

  void remove(TaskModel task) {
    _tasks.remove(task);
  }
}