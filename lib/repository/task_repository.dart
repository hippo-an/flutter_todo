import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_todo/common/firestore_exception.dart';
import 'package:todo_todo/models/task_model.dart';

class TaskRepository {
  final FirebaseFirestore _firestore;

  TaskRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  Future<void> createTask({required TaskModel task}) async {
    try {
      await _firestore.collection('tasks').doc(task.taskId).set(task.toJson());
    } catch (e) {
      throw FirestoreException(message: e.toString());
    }
  }

  Future<TaskModel?> fetchTask(String taskId) async {
    try {
      return await _firestore.collection('tasks').doc(taskId).get()
      .then((value) {
        if (value.data() != null) {
          return TaskModel.fromJson(value.data()!);
        }
      });
    } catch (e) {
      throw FirestoreException(message: e.toString());
    }
  }
}
