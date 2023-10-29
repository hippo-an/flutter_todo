import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarSelectedDateController extends ChangeNotifier {
  DateTime _selectedDate = DateTime.now();

  late String _selectedYearAndMonth;

  CalendarSelectedDateController() {
    _selectedYearAndMonth =
        '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}';
  }

  DateTime get selectedDate => _selectedDate;



  String get selectedYearAndMonth => _selectedYearAndMonth;

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

  bool isSameDatPredicate(DateTime selectedDate) =>
      isSameDay(_selectedDate, selectedDate);


}
