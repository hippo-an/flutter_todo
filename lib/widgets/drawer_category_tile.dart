import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/colors.dart';
import 'package:todo_todo/controller/category_controller.dart';
import 'package:todo_todo/widgets/category_add_button.dart';

class DrawerCategoryTile extends StatelessWidget {
  const DrawerCategoryTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryController>(
      builder: (context, categoryController, child) {
        final categories = categoryController.categories.take(8);
        return Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: false,
            leading: Icon(
              Icons.category,
              color: Theme.of(context).colorScheme.primary,
              size: 26,
            ),
            title: const Text('Categories'),
            children: categories.isEmpty
                ? [
                    const CircularProgressIndicator(),
                    const CategoryAddButton(),
                  ]
                : [
                    ...categories.map(
                      (category) {
                        int count = category.taskCount;
                        if (category.isDefault) {
                          count = categories
                              .map((e) => e.taskCount)
                              .reduce((value, element) => value + element);
                        }

                        return InkWell(
                          onTap: () {
                            final controller = Provider.of<CategoryController>(
                                context,
                                listen: false);
                            if (controller.selectedCategory != category) {
                              controller.updateSelectedCategoryId(
                                  category.categoryId);
                              Navigator.of(context).pop();
                            }
                          },
                          splashColor: kGreyColor,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.background,
                            ),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: ListTile(
                              isThreeLine: false,
                              title: Text(
                                category.name,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Text('$count'),
                            ),
                          ),
                        );
                      },
                    ).toList(),
                    const CategoryAddButton(),
                  ],
          ),
        );
      },
    );
  }
}
