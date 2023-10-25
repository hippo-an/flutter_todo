import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/controller/category_controller.dart';
import 'package:todo_todo/widgets/category_add_button.dart';

class DrawerCategoryTile extends StatelessWidget {
  const DrawerCategoryTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryController>(
      builder: (context, categoryController, child) {
        final categories = categoryController.categories;
        return Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            onExpansionChanged: (value) {},
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
                    ...categories
                        .map(
                          (category) => Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.background,
                            ),
                            // key: UniqueKey(),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: InkWell(
                              onTap: () {},
                              child: ListTile(
                                isThreeLine: false,
                                title: Text(
                                  category.name,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: Text('${category.taskCount}'),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    const CategoryAddButton(),
                  ],
          ),
        );
      },
    );
  }
}
