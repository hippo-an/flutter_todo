import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/components/add_category_alert_dialog.dart';
import 'package:todo_todo/consts/enums.dart';
import 'package:todo_todo/provider/selected_category_provider.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final categories = categoryProvider.categories.sublist(1);

    return ReorderableListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return ListTile(
          key: ValueKey<String>(category.id),
          isThreeLine: false,
          leading: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: category.color,
            ),
          ),
          title: Text(category.name),
          trailing: MenuAnchor(
            builder: (
              BuildContext context,
              MenuController controller,
              Widget? child,
            ) {
              return IconButton(
                onPressed: () {
                  controller.isOpen ? controller.close() : controller.open();
                },
                icon: const Icon(Icons.more_vert),
                tooltip: 'Show menu',
              );
            },
            menuChildren: <MenuItemButton>[
              MenuItemButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AddCategoryAlertDialog(
                        isEditMode: true,
                        color: category.color,
                        name: category.name,
                        categoryIndex: index,
                      );
                    },
                  );
                },
                child: Text('edit'),
              ),
              MenuItemButton(
                onPressed: () {},
                child: Text(
                  category.categoryState == CategoryState.activated
                      ? 'deactivate'
                      : 'activate',
                ),
              ),
              MenuItemButton(
                onPressed: () {},
                child: const Text('delete'),
              ),
            ],
          ),
        );
      },
      onReorder: (int oldIndex, int newIndex) {
        if (oldIndex == newIndex) {
          return;
        }

        categoryProvider.reorderCategory(oldIndex, newIndex);
      },
    );
  }
}
