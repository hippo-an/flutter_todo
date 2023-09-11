import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_todo/screens/manage_category_screen.dart';
import 'package:todo_todo/screens/task_list_screen.dart';
import 'package:todo_todo/screens/todo_navigation_screen.dart';

const _menuList = ['Manage Categories', 'Change Default Color'];

class CategoryBarMenuAnchor extends StatelessWidget {
  const CategoryBarMenuAnchor({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MenuAnchor(
        builder: (
          BuildContext context,
          MenuController controller,
          Widget? child,
        ) {
          return IconButton(
            onPressed: () {
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            },
            icon: const Icon(Icons.more_vert),
            tooltip: 'Show menu',
          );
        },
        menuChildren: List<MenuItemButton>.generate(
          _menuList.length,
          (int index) => MenuItemButton(
            onPressed: () {
              if (index == 0) {
                context.push(
                    '${TodoNavigationScreen.routeName}${TaskListScreen.routeName}/${ManageCategoryScreen.routeName}');
              } else if (index == 1) {

              }
            },
            child: Text(_menuList[index]),
          ),
        ),
      ),
    );
  }
}
