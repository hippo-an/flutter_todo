import 'package:flutter/material.dart';
import 'package:todo_todo/widgets/category_alert_dialog.dart';

class DrawerCategoryTile extends StatelessWidget {
  const DrawerCategoryTile({super.key});

  @override
  Widget build(BuildContext context) {
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
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
            ),
            // key: UniqueKey(),
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: InkWell(
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onTap: () {},
              splashColor: Colors.grey[800],
              child: const ListTile(
                isThreeLine: false,
                title: Text(
                  'category name',
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text('0'),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: InkWell(
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onTap: () {},
              splashColor: Colors.grey[800],
              child: const ListTile(
                isThreeLine: false,
                title: Text(
                  'category name',
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text('0'),
              ),
            ),
          ),
          ListTile(
            title: TextButton.icon(
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
  }
}
