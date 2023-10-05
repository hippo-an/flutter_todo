import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/components/common/category_alert_dialog.dart';
import 'package:todo_todo/provider/category_list_provider.dart';
import 'package:todo_todo/provider/drawer_provider.dart';

class DrawerCategoryTile extends StatelessWidget {
  const DrawerCategoryTile({super.key});

  @override
  Widget build(BuildContext context) {
    final drawerCategoryProvider =
        Provider.of<DrawerProvider>(context, listen: false);

    return Consumer<CategoryListProvider>(
      builder: (BuildContext context, categoryProvider, Widget? child) {
        final selectedCategory = categoryProvider.selectedCategory;
        final categories = categoryProvider.seenCategories;
        return Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            onExpansionChanged: (value) {
              drawerCategoryProvider.updateDrawerCategoryOpenStatus();
            },
            initiallyExpanded: drawerCategoryProvider.drawerCategoryStatus,
            leading: const Icon(
              Icons.category,
              size: 26,
            ),
            title: const Text('Category'),
            children: [
              ...categories.map(
                (category) => Container(
                  decoration: category == selectedCategory
                      ? BoxDecoration(
                          color: Colors.grey[200],
                        )
                      : null,
                  key: ValueKey(category.categoryId),
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: InkWell(
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onTap: () {
                      if (selectedCategory != category) {
                        categoryProvider.updateSelectedCategory(category);
                        Scaffold.of(context).closeDrawer();
                      }
                    },
                    splashColor: Colors.grey[800],
                    child: ListTile(
                      isThreeLine: false,
                      title: Text(
                        category.name,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                        category.isDefault
                            ? '${categoryProvider.totalCount}'
                            : '${category.taskCount}',
                      ),
                    ),
                  ),
                ),
              ),
              ListTile(
                title: OutlinedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const CategoryAlertDialog();
                      },
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('new'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
