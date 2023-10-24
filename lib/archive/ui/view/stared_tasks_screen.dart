import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/archive/core/view_models/task_view_model.dart';
import 'package:todo_todo/archive/ui/shared/task_list_item.dart';
import 'package:todo_todo/archive/ui/view/task_detail_screen.dart';

class StaredTaskScreen extends StatelessWidget {
  const StaredTaskScreen({super.key});

  static String routeName = 'stared-tasks';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stared Tasks'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Consumer<TaskViewModel>(
          builder:
              (BuildContext context, TaskViewModel provider, Widget? child) {
            final staredTask = provider.staredTask;
            return ListView.builder(
              itemCount: staredTask.length,
              itemBuilder: (context, index) {
                final task = staredTask[index];
                return GestureDetector(
                onTap: () {
                  context.pushNamed(TaskDetailScreen.routeName, extra: task);
                },
                child: TaskListItem(
                  task: task,
                  taskItemState: TaskItemState.stared,
                ),
              );
              },
            );
          },
        ),
      ),
    );
  }
}
