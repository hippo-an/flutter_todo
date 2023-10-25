import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/controller/category_controller.dart';

class CategoryListBar extends StatelessWidget {
  const CategoryListBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<CategoryController>(
        builder: (context, categoryController, child) {
          final categories = categoryController.categories;
          if (categories.isEmpty) {
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
                      borderRadius: BorderRadius.circular(15),
                    ),
                    side: const BorderSide(
                      width: 3,
                      color: Colors.black,
                    ),
                    backgroundColor: category.color,
                  ),
                  onPressed: () {},
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
