import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/colors.dart';
import 'package:todo_todo/controller/category_controller.dart';
import 'package:todo_todo/widgets/category_list_item.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Consumer<CategoryController>(
            builder: (
              context,
              categoryController,
              child,
            ) {
              final categories = categoryController.categoriesWithoutDefault;

              if (categories.isEmpty) {
                return const Center(
                  child: Text('Category is empty!'),
                );
              }

              return ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return CategoryListItem(
                    key: ValueKey(category.categoryId),
                    category: category,
                  );
                },
              );
            },
          ),
        ),
        const Text(
          'Ordering impossible.. :)',
          style: TextStyle(
            color: kGreyColor,
          ),
        )
      ],
    );
  }
}
