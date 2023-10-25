import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_todo/archive/core/services/repository/task_repository.dart';
import 'package:todo_todo/archive/locator.dart';

class MainCalendarProvider extends ChangeNotifier {
  final TaskRepository taskRepository;
  MainCalendarProvider() : taskRepository = locator<TaskRepository>();
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  CalendarFormat get calendarFormat => _calendarFormat;

  DateTime get selectedDate => _selectedDate;

  bool selectedDayPredicate(DateTime selectedDate) =>
      isSameDay(_selectedDate, selectedDate);

  void updateSelectedDate(DateTime newSelectedDate) {
    _selectedDate = newSelectedDate;
    notifyListeners();
  }

  void updateCalendarFormat(CalendarFormat newCalendarFormat) {
    _calendarFormat = newCalendarFormat;
    notifyListeners();
  }

  void selectToday() {
    final now = DateTime.now();
    _selectedDate = DateTime.utc(
      now.year,
      now.month,
      now.day,
    );
    notifyListeners();
  }
}
