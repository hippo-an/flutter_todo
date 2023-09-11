import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/provider/selected_category_provider.dart';

class DrawerCategoryTile extends StatelessWidget {
  const DrawerCategoryTile({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final categories = categoryProvider.categories;

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        initiallyExpanded: true,
        leading: const Icon(
          Icons.category,
          size: 26,
        ),
        title: const Text('Category'),
        children: [
          ...categories.map(
                (category) =>
                Padding(
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
        ],
      ),
    );
  }
}
