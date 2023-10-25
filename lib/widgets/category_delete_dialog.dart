import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/colors.dart';
import 'package:todo_todo/controller/category_controller.dart';
import 'package:todo_todo/models/category_model.dart';

class CategoryDeleteDialog extends StatelessWidget {
  const CategoryDeleteDialog({
    super.key,
    required this.category,
  });

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete category'),
      content:
          const Text('If you delete category included task will delete too.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: kRedColor),
          ),
          onPressed: () async {
            await Provider.of<CategoryController>(context, listen: false)
                .deleteCategory(context, category.categoryId);

            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
          child: const Text(
            'Delete',
            style: TextStyle(
              color: kRedColor,
            ),
          ),
        ),
      ],
    );
  }
}
