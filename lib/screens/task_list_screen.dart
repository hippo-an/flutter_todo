import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/components/category_bar_menu_anchor.dart';
import 'package:todo_todo/components/custom_floating_action_button.dart';
import 'package:todo_todo/components/task_list_screen/category_list_bar.dart';
import 'package:todo_todo/models/task_model.dart';
import 'package:todo_todo/provider/selected_category_provider.dart';
import 'package:todo_todo/provider/task_list_provider.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  static const routeName = 'tasks';

  @override
  Widget build(BuildContext context) {
    final taskListProvider = Provider.of<TaskListProvider>(context);
    final selectedCategoryProvider =
        Provider.of<SelectedCategoryProvider>(context);
    final selectedCategory = selectedCategoryProvider.selectedCategory;
    final tasks = taskListProvider.tasks(selectedCategory);

    return Scaffold(
      floatingActionButton: const CustomFloatingActionButton(),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
            width: double.infinity,
            child: Row(
              children: [
                CategoryListBar(
                  selectedCategory: selectedCategory,
                ),
                const CategoryBarMenuAnchor(),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 8),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final TaskModel task = tasks[index];
                return CheckboxListTile(
                  value: task.isDone,
                  onChanged: (bool? value) {

                  },
                  title: Text(task.taskName),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
