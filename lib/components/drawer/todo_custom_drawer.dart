import 'package:flutter/material.dart';
import 'package:todo_todo/components/task_list_screen/add_category_alert_dialog.dart';
import 'package:todo_todo/components/drawer/drawer_category_tile.dart';

class TodoCustomDrawer extends StatelessWidget {
  const TodoCustomDrawer({super.key});

  static const routeName = 'drawer';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const BeveledRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: ListView(
        children: [
          const DrawerHeader(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'TodoTodo',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const DrawerCategoryTile(),
          ListTile(
            title: Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
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
          ),
        ],
      ),
    );
  }
}
