import 'package:flutter/material.dart';
import 'package:todo_todo/common/enums.dart';

class TaskListSectionProvider extends ChangeNotifier {
  bool _isPastOpen = true;
  bool _isTodayOpen = true;
  bool _isFutureOpen = true;
  bool _isCompleteTodyOpen = true;

  bool get isPastOpen => _isPastOpen;

  bool get isTodayOpen => _isTodayOpen;

  bool get isFutureOpen => _isFutureOpen;

  bool get isCompleteTodyOpen => _isCompleteTodyOpen;

  void update(TaskListSectionState taskListSectionState) {
    switch (taskListSectionState) {
      case TaskListSectionState.past:
        _isPastOpen = !_isPastOpen;
      case TaskListSectionState.today:
        _isTodayOpen = !_isTodayOpen;
      case TaskListSectionState.future:
        _isFutureOpen = !_isFutureOpen;
      case TaskListSectionState.complete:
        _isCompleteTodyOpen = !_isCompleteTodyOpen;
    }
    notifyListeners();
  }

  openState(TaskListSectionState taskListSectionState) =>
      switch (taskListSectionState) {
        TaskListSectionState.past => _isPastOpen,
        TaskListSectionState.today => _isTodayOpen,
        TaskListSectionState.future => _isFutureOpen,
        TaskListSectionState.complete => _isCompleteTodyOpen,
      };
}
