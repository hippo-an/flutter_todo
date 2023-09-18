import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/components/custom_floating_action_button.dart';
import 'package:todo_todo/components/task_list_screen/task_list_box.dart';
import 'package:todo_todo/components/task_list_screen/top_bar.dart';
import 'package:todo_todo/provider/selected_category_provider.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  static const routeName = 'tasks';

  @override
  Widget build(BuildContext context) {
    final selectedCategoryProvider =
        Provider.of<SelectedCategoryProvider>(context);
    final selectedCategory = selectedCategoryProvider.selectedCategory;

    return Scaffold(
      floatingActionButton: const CustomFloatingActionButton(),
      body: Column(
        children: [
          CategoryBar(selectedCategory: selectedCategory),
          const SizedBox(height: 10),
          TaskListBox(selectedCategory: selectedCategory),
        ],
      ),
    );
  }
}
