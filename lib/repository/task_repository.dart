import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_todo/common/firestore_exception.dart';
import 'package:todo_todo/models/category_model.dart';
import 'package:todo_todo/models/marker_model.dart';
import 'package:todo_todo/models/subtask_model.dart';
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
      return await _firestore
          .collection('tasks')
          .doc(taskId)
          .get()
          .then((value) {
        if (value.data() != null) {
          return TaskModel.fromJson(value.data()!);
        }
      });
    } catch (e) {
      throw FirestoreException(message: e.toString());
    }
  }

  Stream<List<TaskModel>> categoryNotDoneTask(
      CategoryModel selectedCategory, List<String> seenCategoryIds) {
    return _firestore
        .collection('tasks')
        .where('categoryId', isEqualTo: selectedCategory.categoryId)
        .where('isDeleted', isEqualTo: false)
        .where('isDone', isEqualTo: false)
        .where('categoryId', whereIn: seenCategoryIds)
        .orderBy('dueDate')
        .limit(100)
        .snapshots()
        .map(
          (query) => query.docs
              .map(
                (e) => TaskModel.fromJson(
                  e.data(),
                ),
              )
              .toList(),
        );
  }

  Stream<List<TaskModel>> categoryTodayDoneTask(
      CategoryModel selectedCategory, List<String> seenCategoryIds) {
    final now = DateTime.now();
    final from = DateTime(now.year, now.month, now.day).toString();
    final to = DateTime(now.year, now.month, now.day + 1).toString();
    return _firestore
        .collection('tasks')
        .where('categoryId', isEqualTo: selectedCategory.categoryId)
        .where('isDeleted', isEqualTo: false)
        .where('isDone', isEqualTo: true)
        .where('categoryId', whereIn: seenCategoryIds)
        .where('completedDate', isGreaterThanOrEqualTo: from)
        .where('completedDate', isLessThan: to)
        .orderBy('completedDate')
        .limit(100)
        .snapshots()
        .map(
          (query) => query.docs
              .map(
                (e) => TaskModel.fromJson(
                  e.data(),
                ),
              )
              .toList(),
        );
  }

  Stream<List<TaskModel>> defaultNotDoneTask(
      String uid, List<String> seenCategoryIds) {
    return _firestore
        .collection('tasks')
        .where('categoryId', whereIn: seenCategoryIds)
        .where('uid', isEqualTo: uid)
        .where('isDeleted', isEqualTo: false)
        .where('isDone', isEqualTo: false)
        .orderBy('dueDate')
        .limit(100)
        .snapshots()
        .map(
          (query) => query.docs
              .map(
                (e) => TaskModel.fromJson(
                  e.data(),
                ),
              )
              .toList(),
        );
  }

  Stream<List<TaskModel>> defaultTodayDoneTask(
      String uid, List<String> seenCategoryIds) {
    final now = DateTime.now();
    final from = DateTime(now.year, now.month, now.day).toString();
    final to = DateTime(now.year, now.month, now.day + 1).toString();
    return _firestore
        .collection('tasks')
        .where('uid', isEqualTo: uid)
        .where('isDeleted', isEqualTo: false)
        .where('isDone', isEqualTo: true)
        .where('categoryId', whereIn: seenCategoryIds)
        .where('completedDate', isGreaterThanOrEqualTo: from)
        .where('completedDate', isLessThan: to)
        .orderBy('completedDate')
        .limit(100)
        .snapshots()
        .map(
          (query) => query.docs
              .map(
                (e) => TaskModel.fromJson(
                  e.data(),
                ),
              )
              .toList(),
        );
  }

  Future<void> updateTaskToDone(
      {required String taskId, required bool isDone}) async {
    try {
      final now = DateTime.now().toString();
      return await _firestore.collection('tasks').doc(taskId).update({
        'isDone': isDone,
        'updatedAt': now,
        'completedDate': isDone ? now : 'null',
      });
    } catch (e) {
      throw FirestoreException(message: e.toString());
    }
  }

  Future<void> deleteTask({
    required String taskId,
    required String defaultCategoryId,
  }) async {
    try {
      await _firestore.collection('tasks').doc(taskId).update({
        'isDeleted': true,
        'deletedAt': DateTime.now().toString(),
        'categoryId': defaultCategoryId,
      });
    } catch (e) {
      throw FirestoreException(message: e.toString());
    }
  }

  Future<void> startStateChange({
    required String taskId,
    required bool value,
  }) async {
    try {
      await _firestore.collection('tasks').doc(taskId).update({
        'stared': value,
        'updatedAt': DateTime.now().toString(),
      });
    } catch (e) {
      throw FirestoreException(message: e.toString());
    }
  }

  Future<void> updateDueDate(
      {required String taskId, DateTime? dueDate}) async {
    try {
      await _firestore.collection('tasks').doc(taskId).update({
        'dueDate': dueDate == null ? 'null' : dueDate.toString(),
        'updatedAt': DateTime.now().toString(),
      });
    } catch (e) {
      throw FirestoreException(message: e.toString());
    }
  }

  Stream<TaskModel> task(String taskId) {
    try {
      return _firestore.collection('tasks').doc(taskId).snapshots().map(
            (query) => TaskModel.fromJson(
              query.data()!,
            ),
          );
    } catch (e) {
      throw FirestoreException(message: e.toString());
    }
  }

  Future<void> updateCategory(
      {required String taskId, required String categoryId}) async {
    try {
      await _firestore.collection('tasks').doc(taskId).update({
        'categoryId': categoryId,
        'updatedAt': DateTime.now().toString(),
      });
    } catch (e) {
      throw FirestoreException(message: e.toString());
    }
  }

  Future<void> updateTaskName({
    required String taskId,
    required String taskName,
  }) async {
    try {
      await _firestore.collection('tasks').doc(taskId).update({
        'taskName': taskName,
        'updatedAt': DateTime.now().toString(),
      });
    } catch (e) {
      throw FirestoreException(message: e.toString());
    }
  }

  Future<void> updateNote(
      {required String taskId, required String note}) async {
    try {
      await _firestore.collection('tasks').doc(taskId).update({
        'note': note,
        'updatedAt': DateTime.now().toString(),
      });
    } catch (e) {
      throw FirestoreException(message: e.toString());
    }
  }

  Future<void> updateSubtask({
    required String taskId,
    required List<SubtaskModel> subtasks,
  }) async {
    try {
      await _firestore.collection('tasks').doc(taskId).update({
        'subtasks': subtasks.map((e) => e.toJson()),
        'updatedAt': DateTime.now().toString(),
      });
    } catch (e) {
      throw FirestoreException(message: e.toString());
    }
  }

  Future<void> deleteTaskByCategory({
    required String categoryId,
    required String defaultCategoryId,
  }) async {
    try {
      final tasks = await _firestore
          .collection('tasks')
          .where(
            'categoryId',
            isEqualTo: categoryId,
          )
          .get();

      final batch = _firestore.batch();

      for (final doc in tasks.docs) {
        final String taskId = doc.data()['taskId'];
        final task = _firestore.collection('tasks').doc(taskId);
        batch.update(task, {
          'isDeleted': true,
          'deletedAt': DateTime.now().toString(),
          'categoryId': defaultCategoryId,
        });
      }

      await batch.commit();
    } catch (e) {
      throw FirestoreException(message: e.toString());
    }
  }

  Future<void> returnTask({required String taskId}) async {
    try {
      await _firestore.collection('tasks').doc(taskId).update({
        'isDeleted': false,
        'deletedAt': 'null',
      });
    } catch (e) {
      throw FirestoreException(message: e.toString());
    }
  }

  Future<void> deleteTaskPermanently({required String taskId}) async {
    try {
      await _firestore.collection('tasks').doc(taskId).delete();
    } catch (e) {
      throw FirestoreException(message: e.toString());
    }
  }

  Future<List<TaskModel>> calendarTasks(DateTime selectedDate) async {
    try {
      final snap = await _firestore.collection('tasks').get();
      return snap.docs
          .map(
            (e) => TaskModel.fromJson(
              e.data(),
            ),
          )
          .toList();
    } catch (e) {
      throw FirestoreException(message: e.toString());
    }
  }

  Future<List<TaskModel>> selectedDateTasks({
    required String uid,
    required DateTime selectedDate,
    required List<String> categoryIds,
  }) async {
    try {
      final from =
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      final to = from.copyWith(day: selectedDate.day + 1);

      final snap = await _firestore
          .collection('tasks')
          .where('uid', isEqualTo: uid)
          .where('isDeleted', isEqualTo: false)
          .where('categoryId', whereIn: categoryIds)
          .where(
            'dueDate',
            isGreaterThanOrEqualTo: from.toString(),
          )
          .where(
            'dueDate',
            isLessThan: to.toString(),
          )
          .orderBy('dueDate')
          .get();

      // stream ..
      // return snap.map(
      //   (e) => e.docs
      //       .map(
      //         (e) => TaskModel.fromJson(
      //           e.data(),
      //         ),
      //       )
      //       .toList(),
      // );
      return snap.docs
          .map(
            (e) => TaskModel.fromJson(
              e.data(),
            ),
          )
          .toList();
    } catch (e) {
      throw FirestoreException(message: e.toString());
    }
  }

  Future<List<MarkerModel>> fetchMarkerData({
    required String uid,
    required DateTime selectedMonth,
    required List<String> categoryIds,
  }) async {
    try {
      final from = DateTime(selectedMonth.year, selectedMonth.month, 1);
      final to = DateTime(selectedMonth.year, selectedMonth.month + 1, 1);

      final snap = await _firestore
          .collection('tasks')
          .where('uid', isEqualTo: uid)
          .where('isDeleted', isEqualTo: false)
          .where('categoryId', whereIn: categoryIds)
          .where(
            'dueDate',
            isGreaterThanOrEqualTo: from.toString(),
          )
          .where(
            'dueDate',
            isLessThan: to.toString(),
          )
          .orderBy('dueDate')
          .get();

      return snap.docs
          .map(
            (e) => MarkerModel.fromJson(
              e.data(),
            ),
          )
          .toList();
    } catch (e) {
      throw FirestoreException(message: e.toString());
    }
  }
}
