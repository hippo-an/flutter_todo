import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_todo/controller/task_tab_open_controller.dart';
import 'package:todo_todo/enums.dart';
import 'package:todo_todo/locator.dart';
import 'package:todo_todo/models/task_model.dart';
import 'package:todo_todo/widgets/task_list_block.dart';

class CompleteTaskListSection extends StatelessWidget {
  const CompleteTaskListSection({
    super.key,
    required this.tasks,
  });

  final List<TaskModel> tasks;

  @override
  Widget build(BuildContext context) {
    final controller = locator<TaskTabOpenController>();
    final now = DateTime.now();

    final complete =
        tasks.where((task) => isSameDay(task.completedDate, now)).toList();
    return Column(
      children: [
        if (complete.isNotEmpty)
          TaskListBlock(
            tasks: complete,
            taskListBlockState: TaskListBlockState.complete,
            open: controller.completeTodayOpen,
          ),
      ],
    );
  }
}
