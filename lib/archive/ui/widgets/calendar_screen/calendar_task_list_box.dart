import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/archive/core/view_models/main_calendar_provider.dart';
import 'package:todo_todo/archive/core/view_models/task_view_model.dart';
import 'package:todo_todo/archive/ui/shared/task_list_item.dart';

class CalendarTaskListBox extends StatelessWidget {
  const CalendarTaskListBox({super.key});

  @override
  Widget build(BuildContext context) {
    final taskListProvider = Provider.of<TaskViewModel>(context);
    final mainCalendarProvider = Provider.of<MainCalendarProvider>(context);

    final calendarList = taskListProvider.calendarList(mainCalendarProvider.selectedDate);
    return Expanded(
      child: ListView.builder(
        itemCount: calendarList.length,
        itemBuilder: (context, index) {
          return TaskListItem(
            task: calendarList[index],
          );
        },
      ),
    );
  }
}
