import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_todo/provider/main_calendar_provider.dart';

class MainCalendarContainer extends StatelessWidget {
  const MainCalendarContainer({
    super.key,
  });

  bool _selectedDayPredicate(DateTime date, DateTime selectedDate) =>
      date.year == selectedDate.year &&
      date.month == selectedDate.month &&
      date.day == selectedDate.day;

  @override
  Widget build(BuildContext context) {
    final mainCalendarProvider = Provider.of<MainCalendarProvider>(context);
    final selectedDate = mainCalendarProvider.selectedDate;
    final calendarFormat = mainCalendarProvider.calendarFormat;

    return Column(
      children: [
        TableCalendar(
          focusedDay: selectedDate,
          firstDay: DateTime(1950, 1, 1),
          lastDay: DateTime(2999, 12, 31),
          calendarFormat: calendarFormat,
          selectedDayPredicate: (date) =>
              _selectedDayPredicate(date, selectedDate),
          onDaySelected: (selectedDay, focusedDay) =>
              mainCalendarProvider.updateSelectedDate(selectedDay),
          headerStyle: const HeaderStyle(
            titleCentered: true,
            formatButtonVisible: false,
            titleTextStyle: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 17.0,
            ),
          ),
          daysOfWeekHeight: 23,
          calendarStyle: const CalendarStyle(
            isTodayHighlighted: false,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  mainCalendarProvider.updateCalendarFormat(
                      calendarFormat == CalendarFormat.month
                          ? CalendarFormat.week
                          : CalendarFormat.month);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                child: calendarFormat == CalendarFormat.month
                    ? const Icon(Icons.keyboard_arrow_up)
                    : const Icon(Icons.keyboard_arrow_down),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () => mainCalendarProvider.selectToday(),
              child: const Text('Today'),
            ),
          ],
        )
      ],
    );
  }
}
