import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/controller/category_controller.dart';
import 'package:todo_todo/locator.dart';
import 'package:todo_todo/repository/auth_repository.dart';
import 'package:todo_todo/repository/task_repository.dart';
import 'package:todo_todo/widgets/task_stream_builder.dart';

class TaskListWidget extends StatelessWidget {
  const TaskListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryController = Provider.of<CategoryController>(context);
    final selectedCategory = categoryController.selectedCategory;
    final seenCategoryIds = categoryController.seenCategoryIds;
    if (selectedCategory == null) {
      return const Expanded(
        child: SingleChildScrollView(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    } else if (selectedCategory.isDefault) {
      return Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TaskStreamBuilder(
                stream: locator<TaskRepository>().defaultNotDoneTask(
                  locator<AuthRepository>().currentUser.uid,
                  seenCategoryIds,
                ),
              ),
              TaskStreamBuilder(
                stream: locator<TaskRepository>().defaultTodayDoneTask(
                  locator<AuthRepository>().currentUser.uid,
                  seenCategoryIds,
                ),
                isComplete: true,
              ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            TaskStreamBuilder(
              stream: locator<TaskRepository>().categoryNotDoneTask(
                selectedCategory,
                seenCategoryIds,
              ),
            ),
            TaskStreamBuilder(
              stream: locator<TaskRepository>().categoryTodayDoneTask(
                selectedCategory,
                seenCategoryIds,
              ),
              isComplete: true,
            ),
          ],
        ),
      ),
    );
  }
}
