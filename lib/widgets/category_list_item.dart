import 'package:flutter/material.dart';
import 'package:todo_todo/colors.dart';
import 'package:todo_todo/enums.dart';
import 'package:todo_todo/models/category_model.dart';
import 'package:todo_todo/widgets/category_list_item_menu_anchor.dart';

class CategoryListItem extends StatelessWidget {
  const CategoryListItem({
    super.key,
    required this.category,
  });

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Theme.of(context).colorScheme.background,
      height: MediaQuery.of(context).size.height * 0.08,
      key: ValueKey<String>(category.categoryId),
      child: Row(
        children: [
          Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: category.color,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              category.name,
              style: const TextStyle(fontSize: 15),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          if (category.isStared)
            const Icon(
              Icons.star,
              color: kGreyColor,
              size: 20,
            ),
          const SizedBox(width: 8),
          if (category.categoryState == CategoryState.hide)
            const Icon(
              Icons.visibility_off,
              color: kGreyColor,
              size: 20,
            ),
          const SizedBox(width: 8),
          Text(
            '${category.taskCount}',
            style: const TextStyle(
              color: kWhiteColor,
            ),
          ),
          CategoryListItemMenuAnchor(category: category),
        ],
      ),
    );
  }
}
