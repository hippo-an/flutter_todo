import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/controller/category_controller.dart';
import 'package:todo_todo/models/category_model.dart';
import 'package:todo_todo/widgets/category_edit_alert_dialog.dart';

class CategorySelectDialog extends StatelessWidget {
  const CategorySelectDialog({super.key});

  void _onCategorySelected(
    BuildContext context, {
    required CategoryModel category,
  }) {
    Navigator.of(context).pop(category);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AlertDialog(
      content: SizedBox(
        height: size.height * 0.7,
        width: size.width * 0.7,
        child: Consumer<CategoryController>(
          builder: (context, categoryController, child) {
            final categories = categoryController.seenCategoriesWithoutDefault;

            return ListView.builder(
              itemCount: categories.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return InkWell(
                    onTap: () {
                      _onCategorySelected(
                        context,
                        category: categoryController.defaultCategory,
                      );
                    },
                    child: const ListTile(
                      isThreeLine: false,
                      title: Text('No Category'),
                    ),
                  );
                } else if (index == categories.length + 1) {
                  return InkWell(
                    onTap: () async {
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return const CategoryEditAlertDialog();
                        },
                      );
                    },
                    child: const ListTile(
                      isThreeLine: false,
                      leading: Icon(Icons.add),
                      title: Text('Create Category'),
                    ),
                  );
                }

                final category = categories[index - 1];

                return InkWell(
                  onTap: () {
                    _onCategorySelected(
                      context,
                      category: category,
                    );
                  },
                  child: ListTile(
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
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
