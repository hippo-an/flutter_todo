import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/archive/core/models/task_model.dart';
import 'package:todo_todo/archive/core/view_models/task_list_section_provider.dart';
import 'package:todo_todo/archive/ui/widgets/task_list_screen/slidable_task_list_item.dart';
import 'package:todo_todo/enums.dart';

class TaskListSection extends StatelessWidget {
  const TaskListSection({
    super.key,
    required this.tasks,
    required this.taskListSectionState,
  });

  final List<TaskModel> tasks;
  final TaskListSectionState taskListSectionState;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              taskListSectionState.mappingValue,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Divider(
                height: 2,
                thickness: 1,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${tasks.length} items',
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(width: 8),
            Selector<TaskListSectionProvider, bool>(
              selector: (_, provider) =>
                  provider.openState(taskListSectionState),
              builder: (_, bool value, Widget? child) {
                return IconButton(
                  onPressed: () {
                    Provider.of<TaskListSectionProvider>(context, listen: false)
                        .update(taskListSectionState);
                  },
                  icon: value
                      ? const Icon(Icons.arrow_drop_up_outlined)
                      : const Icon(Icons.arrow_drop_down_outlined),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        Selector<TaskListSectionProvider, bool>(
          selector: (_, provider) => provider.openState(taskListSectionState),
          builder: (_, bool value, Widget? child) {
            if (!value) {
              return const SizedBox.shrink();
            }

            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.09 * tasks.length,
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final TaskModel task = tasks[index];
                  return SlidableTaskListItem(
                    key: ValueKey(task.taskId),
                    task: task,
                  );
                },
                // onReorder: (int oldIndex, int newIndex) {
                //   if (oldIndex == newIndex) {
                //     return;
                //   }
                //   int offset = oldIndex < newIndex ? 1 : 0;
                //   // categoryProvider.reorderCategory(oldIndex, newIndex - offset);
                // },
              ),
            );
          },
        ),
      ],
    );
  }
}
