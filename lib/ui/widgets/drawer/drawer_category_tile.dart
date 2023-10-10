import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/core/view_models/base_model.dart';
import 'package:todo_todo/core/view_models/category_view_model.dart';
import 'package:todo_todo/core/view_models/drawer_provider.dart';
import 'package:todo_todo/locator.dart';
import 'package:todo_todo/ui/shared/category_alert_dialog.dart';

class DrawerCategoryTile extends StatelessWidget {
  const DrawerCategoryTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => locator<CategoryViewModel>(),
      child: Consumer<CategoryViewModel>(
        builder: (_, model, child) {
          if (model.state == ViewState.busy) {
            return const CircularProgressIndicator();
          }

          final selectedCategory = model.selectedCategory;
          final categories = model.seenCategories;
          return Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              onExpansionChanged: (value) {
                locator<DrawerProvider>().updateDrawerCategoryOpenStatus();
              },
              initiallyExpanded: locator<DrawerProvider>().drawerCategoryStatus,
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
                          model.updateSelectedCategory(category);
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
                              ? '${model.totalCount}'
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
      ),
    );
  }
}
