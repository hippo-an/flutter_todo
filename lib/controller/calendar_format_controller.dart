import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarFormatController extends ChangeNotifier {
  CalendarFormat _calendarFormat = CalendarFormat.month;

  CalendarFormat get calendarFormat => _calendarFormat;

  void updateCalendarFormat(CalendarFormat newFormat) {
    _calendarFormat = newFormat;
    notifyListeners();
  }

  bool isMonthFormat() => _calendarFormat == CalendarFormat.month;
}
