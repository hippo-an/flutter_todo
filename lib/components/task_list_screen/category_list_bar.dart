import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/provider/selected_category_provider.dart';

class CategoryListBar extends StatelessWidget {
  const CategoryListBar({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final categories = categoryProvider.categories;
    final selectedIndex = categoryProvider.selectedIndex;
    return Expanded(
      child: ListView.builder(
        itemCount: categories.length,
        padding: const EdgeInsets.all(4),
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          final category = categories[index];
          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: index == selectedIndex
                    ? Colors.orangeAccent
                    : category.color,
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
              ),
              onPressed: () {
                if (selectedIndex == index) {
                  return;
                }

                categoryProvider.updateSelectedIndex(index);
              },
              child: Text(category.name),
            ),
          );
        },
      ),
    );
  }
}
