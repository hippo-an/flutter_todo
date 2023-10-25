import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/colors.dart';
import 'package:todo_todo/controller/category_controller.dart';

class CategoryListBar extends StatelessWidget {
  const CategoryListBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<CategoryController>(
        builder: (context, categoryController, child) {
          final categories = categoryController.categories;
          final selectedCategory = categoryController.selectedCategory;
          if (categories.isEmpty || selectedCategory == null) {
            return const SizedBox(
              height: 10,
              width: 10,
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: categories.length,
            padding: const EdgeInsets.all(4),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Padding(
                key: ValueKey(category.categoryId),
                padding: const EdgeInsets.only(right: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    side: selectedCategory == category
                        ? const BorderSide(
                            width: 2,
                            color: kWhiteColor,
                          )
                        : null,
                    backgroundColor: category.color,
                  ),
                  onPressed: () {
                    categoryController.updateSelectedCategoryId(category.categoryId);
                  },
                  child: Text(category.name),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
