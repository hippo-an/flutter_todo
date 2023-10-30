import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarSelectedDateController extends ChangeNotifier {
  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;


  void updateSelectedDate(DateTime newDate) {
    _selectedDate = newDate;
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

  bool isSameDatePredicate(DateTime selectedDate) =>
      isSameDay(_selectedDate, selectedDate);


  void init() {
    _selectedDate = DateTime.now();
  }
}
