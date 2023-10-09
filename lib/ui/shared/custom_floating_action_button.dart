import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/core/view_models/category_list_provider.dart';
import 'package:todo_todo/ui/widgets/task_list_screen/task_bottom_sheet.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) => TaskBottomSheet(
            selectedCategory:
                Provider.of<CategoryListProvider>(context, listen: false)
                    .selectedCategory,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(4),
        height: 50,
        width: 50,
        decoration: const BoxDecoration(
          color: Colors.black12,
          shape: BoxShape.circle,
        ),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
