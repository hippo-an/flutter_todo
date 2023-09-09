import 'package:flutter/material.dart';
import 'package:todo_todo/components/add_category_alert_dialog.dart';

class TodoCustomDrawer extends StatelessWidget {
  const TodoCustomDrawer({super.key});

  static const routeName = '/drawer';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const BeveledRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: ListView(
        children: [
          const DrawerHeader(
            child: Text(
              'TodoTodo',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ExpansionTile(
            initiallyExpanded: true,
            leading: const Icon(
              Icons.category,
              size: 26,
            ),
            title: const Text('Category'),
            children: [
              const ListTile(
                title: Text('All'),
              ),
              ListTile(
                title: TextButton.icon(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return const AddCategoryAlertDialog();
                        });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('new'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
