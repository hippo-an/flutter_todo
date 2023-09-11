import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/components/category_list_bar.dart';
import 'package:todo_todo/components/custom_floating_action_button.dart';
import 'package:todo_todo/components/menu_anchor_button.dart';
import 'package:todo_todo/provider/selected_category_provider.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  static const routeName = 'tasks';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const CustomFloatingActionButton(),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.04,
        width: double.infinity,
        child: const Row(
          children: [
            CategoryListBar(),
            MenuAnchorExample(),
          ],
        ),
      ),
    );
  }
}
