import 'package:flutter/material.dart';
import 'package:todo_todo/models/task_model.dart';
import 'package:todo_todo/widgets/slidable_task_list_item.dart';

class TaskListSection extends StatelessWidget {
  const TaskListSection({
    super.key,
    required this.tasks,
  });

  final List<TaskModel> tasks;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'task',
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

          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
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
          ),
        )
      ],
    );
  }
}
