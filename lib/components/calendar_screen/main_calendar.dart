import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_todo/provider/main_calendar_provider.dart';

final Map<DateTime, List<Color>> _events = {
  DateTime(2023, 8, 31): [Colors.red, Colors.amber, Colors.green, Colors.purple, Colors.lightGreen],
  DateTime(2023, 9, 1): [Colors.red, Colors.amber, Colors.green, Colors.purple, Colors.lightGreen],
  DateTime(2023, 9, 25): [Colors.red, Colors.amber, Colors.green, Colors.purple, Colors.lightGreen],
  DateTime(2023, 9, 26): [Colors.red, Colors.amber, Colors.green, Colors.purple, Colors.lightGreen],
  DateTime(2023, 9, 27): [Colors.red, Colors.amber, Colors.green, Colors.purple, Colors.lightGreen],
};

class MainCalendar extends StatelessWidget {
  const MainCalendar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MainCalendarProvider>(
      builder: (BuildContext context, MainCalendarProvider mainCalendarProvider,
          Widget? child) {
        return Column(
          children: [
            TableCalendar(
              focusedDay: mainCalendarProvider.selectedDate,
              firstDay: DateTime(1950, 1, 1),
              lastDay: DateTime(2999, 12, 31),
              calendarFormat: mainCalendarProvider.calendarFormat,
              selectedDayPredicate: (date) =>
                  mainCalendarProvider.selectedDayPredicate(date),
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
                canMarkersOverflow: false,
              ),
              formatAnimationCurve: Curves.easeInOut,
              availableGestures: AvailableGestures.horizontalSwipe,
              onPageChanged: (focusedDay) {},
              calendarBuilders:
                  CalendarBuilders(markerBuilder: (context, date, events) {
                DateTime selectedDate =
                    DateTime(date.year, date.month, date.day);
                final List<Color>? value = _events[selectedDate];
                if (value != null) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      value.length > 4 ? 4 : value.length,
                      (index) => Container(
                        width: 10,
                        height: 10,
                        margin: const EdgeInsets.all(0.5),
                        decoration: BoxDecoration(
                          color: value[index],
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                }
                return null;
              }),
            ),
            Row(
              children: [
                Expanded(
                  child: IconButton(
                    onPressed: () {
                      mainCalendarProvider.updateCalendarFormat(
                          mainCalendarProvider.calendarFormat ==
                                  CalendarFormat.month
                              ? CalendarFormat.week
                              : CalendarFormat.month);
                    },
                    icon: mainCalendarProvider.calendarFormat ==
                            CalendarFormat.month
                        ? const Icon(Icons.keyboard_arrow_up)
                        : const Icon(Icons.keyboard_arrow_down),
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () => mainCalendarProvider.selectToday(),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide.none,
                  ),
                  child: const Text('Today'),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
