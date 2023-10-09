import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_todo/core/services/task_repository.dart';

class MainCalendarProvider extends ChangeNotifier {
  MainCalendarProvider(this.taskRepository);
  final TaskRepository taskRepository;
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
