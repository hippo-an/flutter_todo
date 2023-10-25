import 'package:flutter/material.dart';
import 'package:todo_todo/widgets/category_alert_dialog.dart';

class CategoryAddButton extends StatelessWidget {
  const CategoryAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
    );
  }
}
