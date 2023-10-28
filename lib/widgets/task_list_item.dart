import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/colors.dart';
import 'package:todo_todo/controller/task_controller.dart';
import 'package:todo_todo/models/task_model.dart';
import 'package:todo_todo/utils.dart';
import 'package:todo_todo/widgets/animated_check_box.dart';

enum TaskItemState { stared, deleted, normal, completed }

class TaskListItem extends StatelessWidget {
  const TaskListItem({
    super.key,
    required this.task,
    this.taskItemState = TaskItemState.normal,
    this.onReturn,
    this.onDelete,
  });

  final TaskModel task;
  final TaskItemState taskItemState;
  final void Function()? onReturn;
  final void Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      height: MediaQuery.of(context).size.height * 0.08,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onBackground,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            // decoration: BoxDecoration(
            //   color: task.categoryModel?.color ?? Colors.lightBlue[100],
            //   borderRadius: const BorderRadius.only(
            //     topLeft: Radius.circular(5),
            //     bottomLeft: Radius.circular(5),
            //   ),
            // ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    task.taskName,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    maxLines: 1,
                    style: TextStyle(
                        decoration:
                            task.isDone ? TextDecoration.lineThrough : null,
                        color: task.isDone ? kGreyColor : kWhiteColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 16),
                  ),
                  task.dueDate != null
                      ? const SizedBox(height: 12)
                      : const SizedBox.shrink(),
                  if (task.dueDate != null)
                    Text(
                      formatDate(task.dueDate!),
                      style: TextStyle(
                        fontSize: 12,
                        color: task.isBeforeThanToday ? kRedColor : kGreyColor,
                      ),
                    ),
                  // const SizedBox(height: 4),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Icon(
                  //       task.urgent.properties.iconData,
                  //       color: task.urgent.properties.color,
                  //     ),
                  //     Icon(
                  //       task.importance.properties.iconData,
                  //       color: task.importance.properties.color,
                  //     ),
                  //     Icon(
                  //       task.progression.properties.iconData,
                  //       color: task.progression.properties.color,
                  //     ),
                  //     Icon(
                  //       task.priority.properties.iconData,
                  //       color: task.priority.properties.color,
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
          if (taskItemState == TaskItemState.normal)
            AnimatedCheckBox(
              value: task.isDone,
              onChanged: (bool value) async {
                await Provider.of<TaskController>(context, listen: false)
                    .updateTaskToDone(
                  context,
                  taskId: task.taskId,
                  done: value ?? false,
                );
              },
            ),
          if (taskItemState == TaskItemState.stared)
            IconButton(
              onPressed: () {
                // Provider.of<TaskViewModel>(context, listen: false)
                //     .updateTask(
                //   task: task,
                //   stared: false,
                //   dueDate: task.dueDate,
                //   deletedAt: task.deletedAt,
                // );
              },
              icon: const Icon(Icons.star_outline),
            ),
          if (taskItemState == TaskItemState.deleted)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: onReturn,
                  icon: const Icon(Icons.refresh_outlined),
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete_forever_sharp,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          SizedBox(width: 16),
        ],
      ),
    );
  }
}