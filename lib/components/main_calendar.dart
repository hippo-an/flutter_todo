import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MainCalendar extends StatelessWidget {
  final DateTime selectedDate;
  final OnDaySelected onDaySelected;

  const MainCalendar({
    super.key,
    required this.selectedDate,
    required this.onDaySelected,
  });

  bool _selectedDayPredicate(DateTime date) =>
      date.year == selectedDate.year &&
      date.month == selectedDate.month &&
      date.day == selectedDate.day;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TableCalendar(
      locale: 'ko_kr',
      focusedDay: selectedDate,
      firstDay: DateTime(1950, 1, 1),
      lastDay: DateTime(2999, 12, 31),
      onDaySelected: onDaySelected,
      selectedDayPredicate: _selectedDayPredicate,
      headerStyle: const HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 17.0,
        ),
      ),
      daysOfWeekHeight: 25,
      calendarStyle: CalendarStyle(
        isTodayHighlighted: false,
        defaultDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: colorScheme.primary,
        ),
        weekendDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: colorScheme.primary,
        ),
        selectedDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: colorScheme.primaryContainer,
          border: Border.all(
            color: colorScheme.onPrimaryContainer,
            width: 2.0,
          ),
        ),
        outsideDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: colorScheme.secondaryContainer,
        ),
        defaultTextStyle: TextStyle(
          color: colorScheme.onPrimary,
        ),
        weekendTextStyle: TextStyle(
          color: colorScheme.onPrimary,
        ),
        selectedTextStyle: TextStyle(
          color: colorScheme.onPrimaryContainer,
        ),
        outsideTextStyle: TextStyle(
          color: colorScheme.onSecondaryContainer,
        ),
      ),
      // calendarFormat: CalendarFormat.week,
    );
  }
}
