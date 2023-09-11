import 'package:flutter/material.dart';
import 'package:todo_todo/components/category_list.dart';

class ManageCategoryScreen extends StatelessWidget {
  const ManageCategoryScreen({super.key});

  static const routeName = 'manage_category';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manage Categories'),
        ),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(8),
            child: const CategoryList(),
          ),
        ),
      ),
    );
  }
}
