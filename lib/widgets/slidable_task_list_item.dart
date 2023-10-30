import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/colors.dart';
import 'package:todo_todo/constants.dart';
import 'package:todo_todo/controller/calendar_marker_controller.dart';
import 'package:todo_todo/controller/task_controller.dart';
import 'package:todo_todo/models/task_model.dart';
import 'package:todo_todo/widgets/task_list_item.dart';

class SlidableTaskListItem extends StatelessWidget {
  const SlidableTaskListItem({
    super.key,
    required this.task,
  });

  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<TaskViewModel>(context);
    return Slidable(
      key: ValueKey(task.taskId),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        closeThreshold: 0.3,
        openThreshold: 0.1,
        extentRatio: 0.6,
        children: [
          SlidableAction(
            flex: 1,
            onPressed: (context) async {
              await Provider.of<TaskController>(context, listen: false)
                  .startStateChange(
                context,
                taskId: task.taskId,
                value: !task.stared,
              );
            },
            padding: const EdgeInsets.all(1),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
            icon: task.stared ? Icons.star_outline : Icons.star,
            label: task.stared ? 'Un Star' : 'Star',
          ),
          SlidableAction(
            flex: 1,
            onPressed: (ctx) async {
              final now = DateTime.now();
              final newDueDate = await showDatePicker(
                context: context,
                initialDate: task.dueDate ?? now,
                firstDate: firstDay,
                lastDate: lastDay,
                cancelText: 'Reset',
              );
              final dueDate = task.dueDate;

              if ((dueDate == null && newDueDate != null) ||
                  (dueDate != null && newDueDate == null) ||
                  newDueDate?.year != dueDate?.year ||
                  newDueDate?.month != dueDate?.month ||
                  newDueDate?.day != dueDate?.day) {
                if (context.mounted) {
                  await Provider.of<TaskController>(context, listen: false)
                      .updateDueDate(
                    context,
                    taskId: task.taskId,
                    dueDate: newDueDate,
                  );
                }
              }
            },
            padding: const EdgeInsets.all(1),
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
            icon: Icons.calendar_month_rounded,
            label: 'Date',
          ),
          SlidableAction(
            flex: 1,
            onPressed: (context) async {
              if (task.dueDate != null) {
                Provider.of<CalendarMarkerController>(context, listen: false)
                    .removeMarkerCache(task.dueDate!);
              }

              await Provider.of<TaskController>(context, listen: false)
                  .deleteTask(
                context,
                categoryId: task.categoryId,
                taskId: task.taskId,
              );
            },
            padding: const EdgeInsets.all(1),
            backgroundColor: kRedColor,
            foregroundColor: kWhiteColor,
            icon: Icons.delete_forever,
            label: 'Delete',
          ),
        ],
      ),
      child: TaskListItem(
        key: ValueKey(task.taskId),
        task: task,
      ),
    );
  }
}
