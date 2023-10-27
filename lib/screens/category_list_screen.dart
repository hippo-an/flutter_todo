import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/controller/category_controller.dart';
import 'package:todo_todo/widgets/category_edit_alert_dialog.dart';
import 'package:todo_todo/widgets/category_list.dart';

class CategoryListScreen extends StatefulWidget {
  static const routeName = '/category';

  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<CategoryController>(context, listen: false)
          .fetchCategoriesForInit();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manage Categories'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return const CategoryEditAlertDialog();
                    },
                  );
                },
                icon: const Icon(Icons.add),
              ),
            ),
          ],
        ),
        body: Container(
          color: Theme.of(context).colorScheme.background,
          padding: const EdgeInsets.all(8),
          child: const CategoryList(),
        ),
      ),
    );
  }
}
