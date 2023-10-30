import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_todo/colors.dart';
import 'package:todo_todo/constants.dart';
import 'package:todo_todo/controller/calendar_format_controller.dart';
import 'package:todo_todo/controller/calendar_marker_controller.dart';
import 'package:todo_todo/controller/calendar_selected_date_controller.dart';
import 'package:todo_todo/controller/category_controller.dart';
import 'package:todo_todo/locator.dart';
import 'package:todo_todo/repository/auth_repository.dart';

class MainCalendar extends StatefulWidget {
  const MainCalendar({
    super.key,
  });

  @override
  State<MainCalendar> createState() => _MainCalendarState();
}

class _MainCalendarState extends State<MainCalendar> {
  bool _keepAction = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: _keepAction || _isLoading,
      child: Consumer3<CalendarFormatController, CalendarSelectedDateController,
          CalendarMarkerController>(
        builder: (
          context,
          formatController,
          selectedDateController,
          calendarMarkerController,
          child,
        ) {
          return Column(
            children: [
              TableCalendar(
                focusedDay: selectedDateController.selectedDate,
                firstDay: firstDay,
                lastDay: lastDay,
                calendarFormat: formatController.calendarFormat,
                selectedDayPredicate: (date) =>
                    selectedDateController.isSameDatePredicate(date),
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
                availableGestures: AvailableGestures.none,
                pageAnimationDuration: const Duration(milliseconds: 500),
                pageJumpingEnabled: true,
                onPageChanged: (focusedDay) async {
                  if (!_keepAction) {
                    _keepAction = true;

                    print('page change event **************************');
                    if (!selectedDateController.isSameDatePredicate(focusedDay)) {
                      selectedDateController.updateSelectedDate(focusedDay);
                    }

                    await calendarMarkerController.fetchMarker(
                      uid: locator<AuthRepository>().currentUser.uid,
                      selectedMonth: focusedDay,
                      categoryIds:
                          Provider.of<CategoryController>(context, listen: false)
                              .seenCategoryIds,
                    );

                    await Future.delayed(
                      Duration(
                          milliseconds:
                              formatController.isMonthFormat() ? 2000 : 3000),
                      () {
                        _keepAction = false;
                      },
                    );
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
                    final key = DateTime(date.year, date.month, date.day);
                    final markers = calendarMarkerController.dateMarkers(key);

                    if (markers.isNotEmpty) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          markers.length > 5 ? 5 : markers.length,
                          (index) {
                            final category = context
                                .read<CategoryController>()
                                .findNullableSeenCategory(markers[index]);

                            return category != null
                                ? Container(
                                    width: 10,
                                    height: 10,
                                    margin: const EdgeInsets.all(0.5),
                                    decoration: BoxDecoration(
                                      color: category.color,
                                      shape: BoxShape.circle,
                                    ),
                                  )
                                : const SizedBox.shrink();
                          },
                        ),
                      );
                    }
                    return null;
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
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.4),
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    splashColor: Colors.transparent,
                    splashRadius:16,
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
                  const SizedBox(width: 10),
                  IconButton(
                    splashColor: Colors.transparent,
                    splashRadius:16,
                    onPressed: () async {
                      _isLoading = true;

                      await calendarMarkerController.fetchMarker(
                        uid: locator<AuthRepository>().currentUser.uid,
                        selectedMonth: selectedDateController.selectedDate,
                        categoryIds:
                        Provider.of<CategoryController>(context, listen: false)
                            .seenCategoryIds,
                      );

                      _isLoading = false;
                    },
                    icon: const Icon(
                      Icons.refresh_outlined,
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
      ),
    );
  }
}
