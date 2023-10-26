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

  void update(TaskListBlockState taskListSectionState) {
    switch (taskListSectionState) {
      case TaskListBlockState.past:
        _isPastOpen = !_isPastOpen;
      case TaskListBlockState.today:
        _isTodayOpen = !_isTodayOpen;
      case TaskListBlockState.future:
        _isFutureOpen = !_isFutureOpen;
      case TaskListBlockState.complete:
        _isCompleteTodayOpen = !_isCompleteTodayOpen;
    }
    notifyListeners();
  }

  openState(TaskListBlockState taskListSectionState) =>
      switch (taskListSectionState) {
        TaskListBlockState.past => _isPastOpen,
        TaskListBlockState.today => _isTodayOpen,
        TaskListBlockState.future => _isFutureOpen,
        TaskListBlockState.complete => _isCompleteTodayOpen,
      };
}
