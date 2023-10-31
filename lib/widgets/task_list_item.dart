import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/colors.dart';
import 'package:todo_todo/controller/category_controller.dart';
import 'package:todo_todo/controller/task_controller.dart';
import 'package:todo_todo/models/task_model.dart';
import 'package:todo_todo/utils.dart';
import 'package:todo_todo/widgets/animated_check_box.dart';

enum TaskItemState { stared, deleted, normal, completed }

class TaskListItem extends StatefulWidget {
  const TaskListItem({
    super.key,
    required this.task,
    this.taskItemState = TaskItemState.normal,
  });

  final TaskModel task;
  final TaskItemState taskItemState;

  @override
  State<TaskListItem> createState() => _TaskListItemState();
}

class _TaskListItemState extends State<TaskListItem> {
  late bool _isDone;
  bool _isLoading = false;

  @override
  void initState() {
    _isDone = widget.task.isDone;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: _isLoading,
      child: Container(
        margin: const EdgeInsets.only(bottom: 2),
        height: MediaQuery.of(context).size.height * 0.08,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onBackground,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Container(
              width: 6,
              decoration: BoxDecoration(
                color: Provider.of<CategoryController>(context, listen: false)
                        .findNullableSeenCategory(widget.task.categoryId)
                        ?.color ??
                    Colors.transparent,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.task.taskName,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      maxLines: 1,
                      style: TextStyle(
                          decoration:
                              _isDone ? TextDecoration.lineThrough : null,
                          color: _isDone ? kGreyColor : kWhiteColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 16),
                    ),
                    widget.task.dueDate != null
                        ? const SizedBox(height: 12)
                        : const SizedBox.shrink(),
                    if (widget.task.dueDate != null)
                      Text(
                        formatDate(widget.task.dueDate!),
                        style: TextStyle(
                          fontSize: 12,
                          color: widget.task.isBeforeThanToday
                              ? kRedColor
                              : kGreyColor,
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
            if (widget.taskItemState == TaskItemState.normal)
              AnimatedCheckBox(
                key: ValueKey(widget.task.taskId),
                value: _isDone,
                onChanged: (bool value) async {
                  _isLoading = true;

                  await Provider.of<TaskController>(context, listen: false)
                      .updateTaskToDone(
                    context,
                    taskId: widget.task.taskId,
                    done: value ?? false,
                  )
                      .then((value) {
                    _isLoading = false;
                    _isDone = !_isDone;
                  });
                },
              ),
            if (widget.taskItemState == TaskItemState.stared)
              IconButton(
                splashColor: Colors.transparent,
                splashRadius: 16,
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
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}
