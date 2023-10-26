import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_todo/controller/task_tab_open_controller.dart';
import 'package:todo_todo/enums.dart';
import 'package:todo_todo/locator.dart';
import 'package:todo_todo/models/task_model.dart';
import 'package:todo_todo/widgets/task_list_block.dart';

class NotCompleteTaskListSection extends StatelessWidget {
  const NotCompleteTaskListSection({
    super.key,
    required this.tasks,
  });

  final List<TaskModel> tasks;

  @override
  Widget build(BuildContext context) {
    final controller = locator<TaskTabOpenController>();
    final now = DateTime.now();

    final past = tasks.where((task) => task.isBeforeThanToday).toList();
    final today = tasks.where((task) => isSameDay(task.dueDate, now)).toList();
    final future = tasks.where((task) => task.isFutureThanToday).toList();
    return Column(
      children: [
        if (past.isNotEmpty)
          TaskListBlock(
            tasks: past,
            taskListBlockState: TaskListBlockState.past,
            open: controller.pastOpen,
          ),
        if (today.isNotEmpty)
          TaskListBlock(
            tasks: today,
            taskListBlockState: TaskListBlockState.today,
            open: controller.todayOpen,
          ),
        if (future.isNotEmpty)
          TaskListBlock(
            tasks: future,
            taskListBlockState: TaskListBlockState.future,
            open: controller.futureOpen,
          ),
      ],
    );
  }
}
