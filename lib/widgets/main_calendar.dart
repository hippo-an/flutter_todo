import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_todo/colors.dart';
import 'package:todo_todo/constants.dart';
import 'package:todo_todo/controller/calendar_format_controller.dart';
import 'package:todo_todo/controller/calendar_selected_date_controller.dart';

class MainCalendar extends StatelessWidget {
  const MainCalendar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<CalendarFormatController, CalendarSelectedDateController>(
      builder: (context, formatController, selectedDateController, child) {
        return Column(
          children: [
            TableCalendar(
              focusedDay: selectedDateController.selectedDate,
              firstDay: firstDay,
              lastDay: lastDay,
              calendarFormat: formatController.calendarFormat,
              selectedDayPredicate: (date) =>
                  selectedDateController.isSameDatPredicate(date),
              onDaySelected: (selectedDay, focusedDay) =>
                  selectedDateController.updateSelectedDate(selectedDay),
              headerStyle: const HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
                titleTextStyle: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 17,
                ),
              ),
              daysOfWeekHeight: 25,
              calendarStyle: const CalendarStyle(
                isTodayHighlighted: false,
                canMarkersOverflow: false,
              ),
              formatAnimationCurve: Curves.easeInOut,
              availableGestures: AvailableGestures.horizontalSwipe,
              onPageChanged: (focusedDay) {
                if (!selectedDateController.isSameDatPredicate(focusedDay)) {
                  selectedDateController.updateSelectedDate(focusedDay);
                }
              },
              calendarBuilders: CalendarBuilders(
                dowBuilder: (context, day) {
                  final text = DateFormat.E().format(day);
                  if (day.weekday == DateTime.saturday ||
                      day.weekday == DateTime.sunday) {
                    return Center(
                      child: Text(
                        text,
                        style: TextStyle(
                            color: day.weekday == DateTime.saturday
                                ? Colors.blue
                                : kRedColor),
                      ),
                    );
                  }

                  return Center(
                    child: Text(
                      text,
                      style: const TextStyle(color: kWhiteColor),
                    ),
                  );
                },
                markerBuilder: (context, date, events) {
                  return null;
                  // final List<Color>? value = _events[date];
                  // if (value != null) {
                  //   return Row(
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: List.generate(
                  //       value.length > 4 ? 4 : value.length,
                  //       (index) => Container(
                  //         width: 10,
                  //         height: 10,
                  //         margin: const EdgeInsets.all(0.5),
                  //         decoration: BoxDecoration(
                  //           color: value[index],
                  //           shape: BoxShape.circle,
                  //         ),
                  //       ),
                  //     ),
                  //   );
                  // }
                  // return null;
                },
                defaultBuilder: (context, day, focusedDay) {
                  return Center(
                    child: Text(
                      '${day.day}',
                      style: const TextStyle(color: kWhiteColor, fontSize: 14),
                    ),
                  );
                },
                selectedBuilder: (context, day, focusedDay) {
                  if (day == focusedDay) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${day.day}',
                          style: const TextStyle(
                            color: kWhiteColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: IconButton(
                    onPressed: () {
                      formatController.updateCalendarFormat(
                          formatController.isMonthFormat()
                              ? CalendarFormat.week
                              : CalendarFormat.month);
                    },
                    icon: formatController.isMonthFormat()
                        ? const Icon(Icons.keyboard_arrow_up)
                        : const Icon(Icons.keyboard_arrow_down),
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () => selectedDateController.selectToday(),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: kWhiteColor,
                    ),
                  ),
                  child: const Text(
                    'Today',
                    style: TextStyle(
                      color: kWhiteColor,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
