import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/components/category_menu_anchor.dart';
import 'package:todo_todo/models/category_model.dart';
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
          trailing: CategoryMenuAnchor(
            categoryState: category.categoryState,
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
