import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/controller/category_controller.dart';
import 'package:todo_todo/enums.dart';
import 'package:todo_todo/models/category_model.dart';
import 'package:todo_todo/widgets/category_delete_dialog.dart';
import 'package:todo_todo/widgets/category_edit_alert_dialog.dart';

class CategoryListItemMenuAnchor extends StatelessWidget {
  const CategoryListItemMenuAnchor({
    super.key,
    required this.category,
  });

  final CategoryModel category;

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
            controller.isOpen ? controller.close() : controller.open();
          },
          icon: const Icon(
            Icons.more_vert,
            size: 20,
          ),
          tooltip: 'Show menu',
        );
      },
      menuChildren: <MenuItemButton>[
        if (category.categoryState == CategoryState.seen)
          MenuItemButton(
            onPressed: () async {
              await showDialog<CategoryModel>(
                context: context,
                builder: (context) {
                  return CategoryEditAlertDialog(
                    isEditMode: true,
                    category: category,
                  );
                },
              );
            },
            child: const Text('edit'),
          ),
        MenuItemButton(
          onPressed: () async {
            await Provider.of<CategoryController>(context, listen: false)
                .changeHide(context, category.categoryId, category.categoryState);
          },
          child: Text(
            category.categoryState == CategoryState.seen ? 'hide' : 'seen',
          ),
        ),
        MenuItemButton(
          onPressed: () async {
            await Provider.of<CategoryController>(context, listen: false)
                .changeCategoryStar(context, category.categoryId, category.isStared);
          },
          child: Text(category.isStared ? 'unstar' : 'star'),
        ),
        MenuItemButton(
          onPressed: () async {
            await showDialog<bool>(
              context: context,
              builder: (context) {
                return CategoryDeleteDialog(
                  category: category,
                );
              },
            );
          },
          child: const Text('delete'),
        ),
      ],
    );
  }
}
