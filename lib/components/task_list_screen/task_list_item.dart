import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/models/task_model.dart';
import 'package:todo_todo/provider/task_list_provider.dart';
import 'package:todo_todo/screens/task_detail_screen.dart';

class TaskListItem extends StatelessWidget {
  const TaskListItem({
    super.key,
    required this.task,
  });

  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(TaskDetailScreen.routeName, extra: task);
      },
      child: Slidable(
        key: ValueKey(task.taskId),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {},
              backgroundColor: Colors.yellow!,
              foregroundColor: Colors.white,
              icon: Icons.star_outline,
              label: 'Star',
            ),
            SlidableAction(
              onPressed: (context) {},
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete_forever,
              label: 'Delete',
            ),
          ],
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 2),
          height: MediaQuery.of(context).size.height * 0.08,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              Container(
                width: 10,
                decoration: BoxDecoration(
                  color: task.categoryModel?.color ?? Colors.lightBlue[100],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                  ),
                ),
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
                          color: task.isDone ? Colors.grey : Colors.black,
                        ),
                      ),
                      task.dueDate != null
                          ? const SizedBox(height: 12)
                          : const SizedBox.shrink(),
                      if (task.dueDate != null)
                        Text(
                          '${task.dueDate!.year}-${task.dueDate!.month.toString().padLeft(2, '0')}-${task.dueDate!.day.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontSize: 12,
                            color: task.isBefore()
                                ? Colors.red[300]
                                : Colors.grey[500],
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
              Checkbox(
                value: task.isDone,
                onChanged: (value) {
                  Provider.of<TaskListProvider>(context, listen: false)
                      .updateTask(task: task, isDone: !task.isDone);
                },
                shape: const CircleBorder(),
                activeColor: Colors.grey,
              )
            ],
          ),
        ),
      ),
    );
  }
}
