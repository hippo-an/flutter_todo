import 'package:flutter/material.dart';
import 'package:todo_todo/enums.dart';

class TaskListSectionProvider extends ChangeNotifier {
  bool _isPastOpen = true;
  bool _isTodayOpen = true;
  bool _isFutureOpen = true;
  bool _isCompleteTodayOpen = true;

  bool get isPastOpen => _isPastOpen;

  bool get isTodayOpen => _isTodayOpen;

  bool get isFutureOpen => _isFutureOpen;

  bool get isCompleteTodayOpen => _isCompleteTodayOpen;

  void update(TaskListSectionState taskListSectionState) {
    switch (taskListSectionState) {
      case TaskListSectionState.past:
        _isPastOpen = !_isPastOpen;
      case TaskListSectionState.today:
        _isTodayOpen = !_isTodayOpen;
      case TaskListSectionState.future:
        _isFutureOpen = !_isFutureOpen;
      case TaskListSectionState.complete:
        _isCompleteTodayOpen = !_isCompleteTodayOpen;
    }
    notifyListeners();
  }

  openState(TaskListSectionState taskListSectionState) =>
      switch (taskListSectionState) {
        TaskListSectionState.past => _isPastOpen,
        TaskListSectionState.today => _isTodayOpen,
        TaskListSectionState.future => _isFutureOpen,
        TaskListSectionState.complete => _isCompleteTodayOpen,
      };
}
