import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/archive/common/colors.dart';
import 'package:todo_todo/archive/core/models/task_model.dart';
import 'package:todo_todo/archive/core/view_models/category_view_model.dart';
import 'package:todo_todo/archive/core/view_models/task_view_model.dart';
import 'package:todo_todo/archive/locator.dart';
import 'package:todo_todo/archive/ui/shared/task_list_item.dart';
import 'package:todo_todo/archive/ui/view/task_detail_screen.dart';
import 'package:todo_todo/constants.dart';

class SlidableTaskListItem extends StatelessWidget {
  const SlidableTaskListItem({
    super.key,
    required this.task,
  });

  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskViewModel>(context);
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
                Provider.of<TaskViewModel>(context, listen: false)
                    .updateTask(
                  task: task,
                  stared: !task.stared,
                  dueDate: task.dueDate,
                  deletedAt: task.deletedAt,
                );
              },
              padding: const EdgeInsets.all(1),
              backgroundColor: Colors.yellow,
              foregroundColor:
                  task.stared ? Colors.white : kCategoryDefaultColor,
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

                locator<CategoryViewModel>()
                    .updateCategory(task.categoryId, task: -1);
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
