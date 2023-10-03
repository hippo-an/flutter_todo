import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/models/task_model.dart';
import 'package:todo_todo/provider/category_list_provider.dart';
import 'package:todo_todo/provider/task_list_provider.dart';

enum TaskItemState { stared, deleted, normal, completed }

class TaskListItem extends StatelessWidget {
  const TaskListItem({
    super.key,
    required this.task,
    this.taskItemState = TaskItemState.normal,
  });

  final TaskModel task;
  final TaskItemState taskItemState;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                        color: task.isBeforeThanToday
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
          if (taskItemState == TaskItemState.normal)
            Checkbox(
              value: task.isDone,
              onChanged: (value) {
                Provider.of<TaskListProvider>(context, listen: false)
                    .updateTask(
                  task: task,
                  isDone: value ?? false,
                  completedDate: !task.isDone ? DateTime.now() : null,
                  dueDate: task.dueDate,
                  deletedAt: task.deletedAt,
                );

                if (task.categoryId != null) {
                  Provider.of<CategoryListProvider>(context, listen: false)
                      .updateCategory(task.categoryId!,
                          complete: value ?? false ? 1 : -1);
                }
              },
              shape: const CircleBorder(),
              activeColor: Colors.grey,
            ),
          if (taskItemState == TaskItemState.stared)
            IconButton(
              onPressed: () {
                Provider.of<TaskListProvider>(context, listen: false)
                    .updateTask(
                  task: task,
                  stared: false,
                  dueDate: task.dueDate,
                  deletedAt: task.deletedAt,
                );
              },
              icon: const Icon(Icons.star_outline),
            ),
          if (taskItemState == TaskItemState.deleted)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    Provider.of<TaskListProvider>(context, listen: false)
                        .updateTask(
                      task: task,
                      isDeleted: false,
                      dueDate: task.dueDate,
                      deletedAt: null,
                    );

                    if (task.categoryId != null) {
                      Provider.of<CategoryListProvider>(context, listen: false)
                          .updateCategory(task.categoryId!,
                              task: 1, complete: task.isDone ? 1 : 0);
                    }
                  },
                  icon: const Icon(Icons.undo),
                ),
                IconButton(
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete task permanently'),
                        actions: [
                          TextButton(
                            onPressed: () {},
                            child: const Text('Cancel'),
                          ),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.red)),
                            onPressed: () {},
                            child: const Text(
                              'Delete',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );

                    if (context.mounted) {
                      Provider.of<TaskListProvider>(context, listen: false)
                          .deleteTask(
                        task: task,
                      );
                    }
                  },
                  icon: const Icon(
                    Icons.delete_forever_sharp,
                    color: Colors.red,
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }
}
