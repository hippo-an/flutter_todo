import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/models/category_model.dart';
import 'package:todo_todo/provider/category_list_provider.dart';
import 'package:todo_todo/provider/selected_category_provider.dart';

class CategoryListBar extends StatelessWidget {
  const CategoryListBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<CategoryListProvider, SelectedCategoryProvider>(
      builder: (BuildContext context, CategoryListProvider categoryListProvider,
          SelectedCategoryProvider selectedCategoryProvider, Widget? child) {
        final categories = categoryListProvider.categories;
        final selectedCategory = selectedCategoryProvider.selectedCategory;
        return Expanded(
          child: ListView.builder(
            itemCount: categories.length + 1,
            padding: const EdgeInsets.all(4),
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Padding(
                  key: const ValueKey('All'),
                  padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      side: null == selectedCategory
                          ? const BorderSide(
                        width: 3,
                        color: Colors.black,
                      )
                          : null,
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                    onPressed: () {
                      selectedCategoryProvider.updateSelectedCategory(null);
                    },
                    child: const Text('All'),
                  ),
                );
              }
              final category = categories[index - 1];
              return Padding(
                key: ValueKey(category.categoryId),
                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    side: category == selectedCategory
                        ? const BorderSide(
                      width: 3,
                      color: Colors.black,
                    )
                        : null,
                    backgroundColor: category.color,
                  ),
                  onPressed: () {
                    if (category == selectedCategory) {
                      return;
                    }

                    selectedCategoryProvider.updateSelectedCategory(category);
                  },
                  child: Text(category.name),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
