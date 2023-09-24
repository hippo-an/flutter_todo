import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/components/common/category_alert_dialog.dart';
import 'package:todo_todo/consts/enums.dart';
import 'package:todo_todo/models/category_model.dart';
import 'package:todo_todo/provider/category_list_provider.dart';
import 'package:todo_todo/provider/selected_category_provider.dart';
import 'package:todo_todo/provider/task_list_provider.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<CategoryListProvider, SelectedCategoryProvider>(
      builder: (BuildContext context, CategoryListProvider categoryProvider,
          SelectedCategoryProvider selectedCategoryProvider, Widget? child) {
        final categories = categoryProvider.categories;
        final selectedCategory = selectedCategoryProvider.selectedCategory;
        final taskListProvider =
            Provider.of<TaskListProvider>(context, listen: false);

        if (categories.isEmpty) {
          return const Expanded(
            child: Center(
              child: Text('Category is empty!'),
            ),
          );
        }

        return Expanded(
          child: ReorderableListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return ListTile(
                key: ValueKey<String>(category.categoryId),
                isThreeLine: false,
                leading: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: category.color,
                  ),
                ),
                title: Text(
                  category.name,
                  style: TextStyle(
                    color: category.categoryState == CategoryState.activated
                        ? Colors.black
                        : Colors.grey,
                  ),
                ),
                trailing: MenuAnchor(
                  builder: (
                    BuildContext context,
                    MenuController controller,
                    Widget? child,
                  ) {
                    return IconButton(
                      onPressed: () {
                        controller.isOpen
                            ? controller.close()
                            : controller.open();
                      },
                      icon: const Icon(Icons.more_vert),
                      tooltip: 'Show menu',
                    );
                  },
                  menuChildren: <MenuItemButton>[
                    if (category.categoryState == CategoryState.activated)
                      MenuItemButton(
                        onPressed: () async {
                          final updatedCategory =
                              await showDialog<CategoryModel>(
                            context: context,
                            builder: (context) {
                              return CategoryAlertDialog(
                                isEditMode: true,
                                category: category,
                              );
                            },
                          );
                          selectedCategoryProvider
                              .updateCategory(updatedCategory);
                          taskListProvider.updateCategory(updatedCategory!);
                        },
                        child: const Text('edit'),
                      ),
                    MenuItemButton(
                      onPressed: () {
                        final updatedCategory = categoryProvider.updateCategory(
                          category,
                          categoryState:
                              category.categoryState == CategoryState.activated
                                  ? CategoryState.deactivated
                                  : CategoryState.activated,
                        );

                        selectedCategoryProvider
                            .updateCategory(updatedCategory);
                        taskListProvider.updateCategory(updatedCategory);
                      },
                      child: Text(
                        category.categoryState == CategoryState.activated
                            ? 'deactivate'
                            : 'activate',
                      ),
                    ),
                    MenuItemButton(
                      onPressed: () async {
                        await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Delete category'),
                              content: const Text(
                                  'If you delete category included task will delete too.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel'),
                                ),
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                      side:
                                          const BorderSide(color: Colors.red)),
                                  onPressed: () {
                                    categoryProvider.deleteCategory(category);

                                    if (selectedCategory == category) {
                                      selectedCategoryProvider
                                          .updateSelectedCategory(null);
                                    }

                                    taskListProvider
                                        .deleteTaskByCategory(category);
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
                          },
                        );
                      },
                      child: const Text('delete'),
                    ),
                  ],
                ),
              );
            },
            onReorder: (int oldIndex, int newIndex) {
              if (oldIndex == newIndex ||
                  categories[oldIndex].categoryState ==
                      CategoryState.deactivated) {
                return;
              }
              int offset = oldIndex < newIndex ? 1 : 0;
              categoryProvider.reorderCategory(oldIndex, newIndex - offset);
            },
          ),
        );
      },
    );
  }
}
