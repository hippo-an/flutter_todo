import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/components/common/task_list_item.dart';
import 'package:todo_todo/models/task_model.dart';
import 'package:todo_todo/provider/category_list_provider.dart';
import 'package:todo_todo/provider/task_list_provider.dart';
import 'package:todo_todo/screens/task_detail_screen.dart';

class SlidableTaskListItem extends StatelessWidget {
  const SlidableTaskListItem({
    super.key,
    required this.task,
  });

  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskListProvider>(context);
    return GestureDetector(
      onTap: () {
        context.pushNamed(TaskDetailScreen.routeName, extra: task);
      },
      child: Slidable(
        key: ValueKey(task.taskId),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          closeThreshold: 0.3,
          openThreshold: 0.1,
          extentRatio: 0.6,
          children: [
            SlidableAction(
              flex: 1,
              onPressed: (context) {
                Provider.of<TaskListProvider>(context, listen: false)
                    .updateTask(
                  task: task,
                  stared: !task.stared,
                  dueDate: task.dueDate,
                  deletedAt: task.deletedAt,
                );
              },
              padding: const EdgeInsets.all(1),
              backgroundColor: Colors.yellow!,
              foregroundColor:
              task.stared ? Colors.white : Colors.lightBlueAccent,
              icon: task.stared ? Icons.star_outline : Icons.star,
              label: 'Star',
            ),
            SlidableAction(
              flex: 1,
              onPressed: (context) async {
                final now = DateTime.now();
                final newDueDate = await showDatePicker(
                  context: context,
                  initialDate: task.dueDate ?? now,
                  firstDate: DateTime(now.year - 10),
                  lastDate: DateTime(now.year + 10),
                  cancelText: 'Reset',
                );
                final dueDate = task.dueDate;

                if ((dueDate == null && newDueDate != null) ||
                    (dueDate != null && newDueDate == null) ||
                    newDueDate?.year != dueDate?.year ||
                    newDueDate?.month != dueDate?.month ||
                    newDueDate?.day != dueDate?.day) {
                  provider.updateTask(
                    task: task,
                    dueDate: newDueDate,
                    deletedAt: task.deletedAt,
                  );
                }
              },
              padding: const EdgeInsets.all(1),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: Icons.calendar_month_rounded,
              label: 'Date',
            ),
            SlidableAction(
              flex: 1,
              onPressed: (context) {
                provider.updateTask(
                  task: task,
                  deletedAt: DateTime.now(),
                  isDeleted: true,
                  dueDate: task.dueDate,
                );

                if (task.categoryModel != null) {
                  Provider.of<CategoryListProvider>(context, listen: false)
                      .updateCategory(task.categoryModel!, task: -1,
                      complete: task.isDone ? -1 : 0);
                }
              },
              padding: const EdgeInsets.all(1),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete_forever,
              label: 'Delete',
            ),
          ],
        ),
        child: TaskListItem(task: task),
      ),
    );
  }
}
