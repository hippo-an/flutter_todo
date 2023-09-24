import 'package:flutter/material.dart';
import 'package:todo_todo/components/category_alert_dialog.dart';
import 'package:todo_todo/components/manage_category_screen/category_list.dart';

class ManageCategoryScreen extends StatelessWidget {
  const ManageCategoryScreen({super.key});

  static const routeName = 'manage_category';

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
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Container(
                  height: 30,
                  color: Colors.grey[200],
                  child: Center(
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Category list',
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ),
                const CategoryList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
