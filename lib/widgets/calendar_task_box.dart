import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/controller/calendar_selected_date_controller.dart';
import 'package:todo_todo/controller/category_controller.dart';
import 'package:todo_todo/controller/task_calendar_reload_controller.dart';
import 'package:todo_todo/controller/task_controller.dart';
import 'package:todo_todo/locator.dart';
import 'package:todo_todo/models/task_model.dart';
import 'package:todo_todo/repository/auth_repository.dart';
import 'package:todo_todo/widgets/task_list_item.dart';

class CalendarTaskBox extends StatelessWidget {
  const CalendarTaskBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<CalendarSelectedDateController, CategoryController,
        TaskCalendarReloadController>(
      builder: (
        context,
        calendarController,
        categoryController,
        taskCalendarReloadController,
        child,
      ) {
        final categoryIds = categoryController.seenCategoryIds;

        if (categoryIds.isEmpty) {
          return const Expanded(
            child: CircularProgressIndicator(),
          );
        }

        return Expanded(
          child: FutureBuilder<List<TaskModel>>(
            future: Provider.of<TaskController>(context, listen: false)
                .selectedDateTasks(
              uid: locator<AuthRepository>().currentUser.uid,
              selectedDate: calendarController.selectedDate,
              categoryIds: categoryIds,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return const Center(
                  child: Text('Something went wrong. Please reload.'),
                );
              }

              if (snapshot.hasData) {
                final tasks = snapshot.data;
                if (tasks != null && tasks.isNotEmpty) {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return TaskListItem(
                        key: ValueKey(task.taskId),
                        task: task,
                      );
                    },
                    itemCount: tasks.length,
                  );
                } else {
                  return const Center(
                    child: Text('Empty tasks..'),
                  );
                }
              }

              return const Center(
                child: Text(
                    'Something went wrong.\nPlease waiting or reloading an app.'),
              );
            },
          ),
        );
      },
    );
  }
}
