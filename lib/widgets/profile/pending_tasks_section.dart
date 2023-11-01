import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/controller/category_controller.dart';
import 'package:todo_todo/controller/task_chart_controller.dart';
import 'package:todo_todo/utils.dart';
import 'package:todo_todo/widgets/profile/base_card.dart';
import 'package:todo_todo/widgets/profile/task_pi_chart.dart';

class PendingTasksSection extends StatelessWidget {
  const PendingTasksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final to = dateAdd(DateTime.now(), -1);
    final size = MediaQuery.of(context).size;

    return BaseCard(
      width: size.width,
      height: size.height * 0.32,
      color: Theme.of(context).colorScheme.onBackground,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    'Pending Tasks in Categories',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
                Text(
                  'In 7 Days',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            FutureBuilder(
              future: Provider.of<TaskChartController>(context, listen: false)
                  .fetchPendingTasks(
                days: -7,
                to: to,
                categoryIds:
                    Provider.of<CategoryController>(context, listen: false)
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
                  final categoryAndCount = snapshot.data!;

                  return Expanded(
                    child: Row(children: [
                      TaskPiChart(categoryAndCount: categoryAndCount),
                      _CategoryList(categoryAndCount: categoryAndCount),
                    ]),
                  );
                }

                return const Center(
                  child: Text('Something went wrong.'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryList extends StatelessWidget {
  const _CategoryList({
    super.key,
    required this.categoryAndCount,
  });

  final Map<String, int> categoryAndCount;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: ListView.builder(
          itemCount: categoryAndCount.entries.length,
          padding: const EdgeInsets.all(2),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final entry = categoryAndCount.entries.elementAt(index);
            final category =
                Provider.of<CategoryController>(context, listen: false)
                    .findNullableSeenCategory(entry.key)!;
            return Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle, color: category.color),
                  ),
                  const SizedBox(width: 10),
                  Text(category.isDefault ? 'No Category' : category.name),
                  const SizedBox(width: 10),
                  Text(
                    '${entry.value}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: category.color,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
