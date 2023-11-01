import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/controller/category_controller.dart';
import 'package:todo_todo/controller/task_chart_controller.dart';
import 'package:todo_todo/models/task_model.dart';
import 'package:todo_todo/utils.dart';
import 'package:todo_todo/widgets/profile/base_card.dart';

class NextDaysSection extends StatelessWidget {
  const NextDaysSection({super.key});

  @override
  Widget build(BuildContext context) {
    final from = dateAdd(DateTime.now(), 1);

    return FutureBuilder(
      future: Provider.of<TaskChartController>(context, listen: false)
          .fetchNextNDaysToBeDoneTasks(
        days: 7,
        from: from,
        categoryIds: Provider.of<CategoryController>(context, listen: false)
            .seenCategoryIds,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong.'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasData) {
          final tasks = snapshot.data!;

          return _TaskList(tasks: tasks);
        }

        return const Center(
          child: Text('Something went wrong.'),
        );
      },
    );
  }
}

class _TaskList extends StatelessWidget {
  const _TaskList({
    super.key,
    required this.tasks,
  });

  final List<TaskModel> tasks;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BaseCard(
      width: size.width,
      height: tasks.isEmpty ? 0 : size.height * 0.3,
      color: Theme.of(context).colorScheme.onBackground,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Row(
              children: [
                Text(
                  'Tasks in Next 7 Days',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Container(
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.newspaper,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            task.taskName,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Text(
                          formatDateWithoutYear(task.dueDate!, delim: '-'),
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
