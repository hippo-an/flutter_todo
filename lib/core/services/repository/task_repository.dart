import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_todo/core/models/category_model.dart';
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

  Future<void> deleteTasksByCategory(CategoryModel category) async {
    FirebaseFirestore.instance
        .collection('tasks')
        .where('categoryId', isEqualTo: category.categoryId)
        .get()
        .then(
      (result) {
        for (var task in result.docs) {
          FirebaseFirestore.instance.collection('tasks').doc(task.id).delete();
        }
      },
    ).onError((error, stackTrace) => null);
  }

  Future<List<TaskModel>> fetchTasks(CategoryModel category) async {
    final response = await FirebaseFirestore.instance
        .collection('tasks')
        .where('categoryId', isEqualTo: category.categoryId)
        .get();

    return response.docs
        .map(
          (e) => TaskModel.fromJson(
            e.data(),
          ),
        )
        .toList();
  }
}
