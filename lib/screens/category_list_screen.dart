import 'package:flutter/material.dart';
import 'package:todo_todo/widgets/category_alert_dialog.dart';
import 'package:todo_todo/widgets/category_list.dart';

class CategoryListScreen extends StatelessWidget {
  static const routeName = '/category';
  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manage Categories'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const CategoryAlertDialog();
                    },
                  );
                },
                icon: const Icon(Icons.add),
              ),
            ),
          ],
        ),
        body: Container(
          color: Theme.of(context).colorScheme.background,
          padding: const EdgeInsets.all(8),
          child: const CategoryList(),
        ),
      ),
    );
  }
}
