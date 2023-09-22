import 'package:flutter/material.dart';
import 'package:todo_todo/components/task_list_screen/category_bar_menu_anchor.dart';
import 'package:todo_todo/components/task_list_screen/category_list_bar.dart';

class CategoryBar extends StatelessWidget {
  const CategoryBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.04,
      width: double.infinity,
      child: const Row(
        children: [
          CategoryListBar(),
          CategoryBarMenuAnchor(),
        ],
      ),
    );
  }
}
