import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MainCalendarProvider extends ChangeNotifier {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  CalendarFormat get calendarFormat => _calendarFormat;
  DateTime get selectedDate => _selectedDate;

  void updateSelectedDate(DateTime newSelectedDate) {
    _selectedDate = newSelectedDate;
    notifyListeners();
  }

  void updateCalendarFormat(CalendarFormat newCalendarFormat) {
    _calendarFormat = newCalendarFormat;
    notifyListeners();
  }

  void selectToday() {
    _selectedDate = DateTime.utc(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    notifyListeners();
  }
}
