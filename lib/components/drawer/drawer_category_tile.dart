import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/components/add_category_alert_dialog.dart';
import 'package:todo_todo/provider/category_list_provider.dart';
import 'package:todo_todo/provider/drawer_provider.dart';
import 'package:todo_todo/provider/selected_category_provider.dart';

class DrawerCategoryTile extends StatelessWidget {
  const DrawerCategoryTile({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryListProvider>(context);
    final categories = categoryProvider.categories;
    final drawerCategoryProvider = Provider.of<DrawerProvider>(context);
    final selectedCategoryProvider =
        Provider.of<SelectedCategoryProvider>(context);
    final selectedCategory = selectedCategoryProvider.selectedCategory;

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
              onTap: () {},
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
                onTap: () {},
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
                    return const AddCategoryAlertDialog();
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
  }
}
