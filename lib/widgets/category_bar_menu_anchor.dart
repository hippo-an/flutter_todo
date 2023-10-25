import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_todo/screens/category_list_screen.dart';

const _menuList = ['Manage Categories', 'Change Default Color'];

class CategoryBarMenuAnchor extends StatelessWidget {
  const CategoryBarMenuAnchor({super.key});

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      builder: (
        context,
        controller,
        child,
      ) {
        return IconButton(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: const Icon(
            Icons.more_vert,
            size: 20,
          ),
          tooltip: 'Show menu',
          padding: const EdgeInsets.symmetric(vertical: 8),
        );
      },
      menuChildren: List<MenuItemButton>.generate(
        _menuList.length,
        (int index) => MenuItemButton(
          onPressed: () {
            if (index == 0) {
              context.push(CategoryListScreen.routeName);
            } else if (index == 1) {}
          },
          child: Text(_menuList[index]),
        ),
      ),
    );
  }
}
