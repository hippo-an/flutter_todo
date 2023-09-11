import 'package:flutter/material.dart';
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
          InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onTap: () {},
            splashColor: Colors.grey[800],
            child: const ListTile(
              isThreeLine: false,
              leading: Icon(
                Icons.delete_outline,
                size: 26,
              ),
              title: Text('Manage Delete'),
            ),

          ),
          InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onTap: () {},
            splashColor: Colors.grey[800],
            child: const ListTile(
              isThreeLine: false,
              leading: Icon(
                Icons.settings,
                size: 26,
              ),
              title: Text('Settings'),
            ),
          ),
        ],
      ),
    );
  }
}
