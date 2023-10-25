import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/archive/core/services/category_service.dart';
import 'package:todo_todo/archive/core/view_models/category_view_model.dart';
import 'package:todo_todo/archive/locator.dart';
import 'package:todo_todo/archive/ui/shared/category_alert_dialog.dart';
import 'package:todo_todo/enums.dart';
import 'package:todo_todo/models/category_model.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<CategoryViewModel>(),
      child: Consumer<CategoryViewModel>(
        builder: (_, model, child) {

          final categories = model.categoriesWithoutDefault;

          if (categories.isEmpty) {
            return const Expanded(
              child: Center(
                child: Text('Category is empty!'),
              ),
            );
          }

          return Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return _CategoryItem(category: categories[index]);
              },
              // onReorder: (int oldIndex, int newIndex) {
              //   if (oldIndex == newIndex ||
              //       categories[oldIndex].categoryState == CategoryState.hide) {
              //     return;
              //   }
              //   int offset = oldIndex < newIndex ? 1 : 0;
              //   model.reorderCategory(oldIndex, newIndex - offset);
              // },
            ),
          );
        },
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({
    super.key,
    required this.category,
  });

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
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
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              category.name,
              style: const TextStyle(fontSize: 15),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            category.taskCount.toString(),
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 8),
          if (category.categoryState == CategoryState.hide)
            const Icon(
              Icons.visibility_off,
              color: Colors.grey,
              size: 20,
            ),
          _CategoryMenuAnchor(category: category),
        ],
      ),
    );
  }
}

class _CategoryMenuAnchor extends StatelessWidget {
  const _CategoryMenuAnchor({super.key, required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      builder: (
        BuildContext context,
        MenuController controller,
        Widget? child,
      ) {
        return IconButton(
          onPressed: () {
            controller.isOpen ? controller.close() : controller.open();
          },
          icon: const Icon(Icons.more_vert),
          tooltip: 'Show menu',
        );
      },
      menuChildren: <MenuItemButton>[
        if (category.categoryState == CategoryState.seen)
          MenuItemButton(
            onPressed: () async {
              await showDialog<CategoryModel>(
                context: context,
                builder: (context) {
                  return CategoryAlertDialog(
                    isEditMode: true,
                    category: category,
                  );
                },
              );
            },
            child: const Text('edit'),
          ),
        MenuItemButton(
          onPressed: () {
            locator<CategoryViewModel>().updateCategory(
              category.categoryId,
              categoryState: category.categoryState == CategoryState.seen
                  ? CategoryState.hide
                  : CategoryState.seen,
            );
          },
          child: Text(
            category.categoryState == CategoryState.seen ? 'hide' : 'seen',
          ),
        ),
        MenuItemButton(
          onPressed: () async {
            await showDialog<bool>(
              context: context,
              builder: (context) {
                return _DeleteDialog(
                  category: category,
                );
              },
            );
          },
          child: const Text('delete'),
        ),
      ],
    );
  }
}

class _DeleteDialog extends StatelessWidget {
  const _DeleteDialog({
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
              side: const BorderSide(color: Colors.red)),
          onPressed: () {
            locator<CategoryService>().deleteCategory(category);
            Navigator.of(context).pop();
          },
          child: const Text(
            'Delete',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }
}
