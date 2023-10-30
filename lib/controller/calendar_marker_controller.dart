import 'package:flutter/material.dart';
import 'package:todo_todo/common/firestore_exception.dart';
import 'package:todo_todo/models/marker_model.dart';
import 'package:todo_todo/repository/task_repository.dart';

class CalendarMarkerController extends ChangeNotifier {
  final TaskRepository _taskRepository;

  CalendarMarkerController(this._taskRepository);

  Map<DateTime, Set<String>> _markers = {};

  List<String> dateMarkers(DateTime key) => _markers[key]?.toList() ?? [];

  Future<void> fetchMarker({
    required String uid,
    required DateTime selectedMonth,
    required List<String> categoryIds,
  }) async {
    try {
      final List<MarkerModel> markers = await _taskRepository.fetchMarkerData(
        uid: uid,
        selectedMonth: selectedMonth,
        categoryIds: categoryIds,
      );

      for (final marker in markers) {
        if (_markers.containsKey(marker.dueDate)) {
          _markers.update(
              marker.dueDate, (value) => {...value, marker.categoryId});
        } else {
          _markers.putIfAbsent(
            marker.dueDate,
            () => {marker.categoryId},
          );
        }
      }

      notifyListeners();
    } on FirestoreException catch (e) {
      _markers.clear();
    }
  }

  void init() {
    _markers = {};
  }

  void removeMarkerCache(DateTime dueDate) {
    _markers.remove(
      DateTime(dueDate.year, dueDate.month, dueDate.day),
    );
  }
}
