import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/components/category_alert_dialog.dart';
import 'package:todo_todo/provider/category_list_provider.dart';
import 'package:todo_todo/provider/drawer_provider.dart';
import 'package:todo_todo/provider/selected_category_provider.dart';

class DrawerCategoryTile extends StatelessWidget {
  const DrawerCategoryTile({super.key});

  @override
  Widget build(BuildContext context) {
    print('DrawerCategoryTile build@@@@@@@@@@@@@@@ ');
    final drawerCategoryProvider =
        Provider.of<DrawerProvider>(context, listen: false);

    return Consumer2<CategoryListProvider, SelectedCategoryProvider>(
      builder: (BuildContext context, categoryProvider,
          selectedCategoryProvider, Widget? child) {
        final selectedCategory = selectedCategoryProvider.selectedCategory;
        final categories = categoryProvider.activatedCategories;
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
              Container(
                decoration: null == selectedCategory
                    ? BoxDecoration(
                        color: Colors.grey[300],
                      )
                    : null,
                key: const ValueKey(null),
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: InkWell(
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onTap: () {
                    if (selectedCategory != null) {
                      selectedCategoryProvider.updateSelectedCategory(null);
                    }
                  },
                  splashColor: Colors.grey[800],
                  child: const ListTile(
                    isThreeLine: false,
                    title: Text('All'),
                  ),
                ),
              ),
              ...categories.map(
                (category) => Container(
                  decoration: category == selectedCategory
                      ? BoxDecoration(
                          color: Colors.grey[300],
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
                        selectedCategoryProvider
                            .updateSelectedCategory(category);
                      }
                    },
                    splashColor: Colors.grey[800],
                    child: ListTile(
                      isThreeLine: false,
                      title: Text(category.name),
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
