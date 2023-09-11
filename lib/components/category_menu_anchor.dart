import 'package:flutter/material.dart';
import 'package:todo_todo/consts/enums.dart';

class CategoryMenuAnchor extends StatelessWidget {
  const CategoryMenuAnchor({
    super.key,
    required this.categoryState,
  });

  final CategoryState categoryState;

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      builder: (
        BuildContext context,
        MenuController controller,
        Widget? child,
      ) =>
          IconButton(
        onPressed: () {
          if (controller.isOpen) {
            controller.close();
          } else {
            controller.open();
          }
        },
        icon: const Icon(Icons.more_vert),
        tooltip: 'Show menu',
      ),
      menuChildren: <MenuItemButton>[
        MenuItemButton(
          onPressed: () {},
          child: Text('edit'),
        ),
        MenuItemButton(
          onPressed: () {

          },
          child: Text(
            categoryState == CategoryState.activated
                ? 'deactivate'
                : 'activate',
          ),
        ),
        MenuItemButton(
          onPressed: () {

          },
          child: Text('delete'),
        ),
      ],
    );
  }
}
