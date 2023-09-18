import 'package:flutter/material.dart';
import 'package:todo_todo/consts/tools.dart';
import 'package:todo_todo/models/category_model.dart';

class CategoryListProvider extends ChangeNotifier {
  final List<CategoryModel> _categories = [];

  List<CategoryModel> get categories => _categories;

  CategoryModel createCategory(String name) {
    final now = DateTime.now();
    final category = CategoryModel(
      categoryId: uuid.generate(),
      name: name,
      colorCode: Colors.lightBlueAccent.value,
      createdAt: now,
      updatedAt: now,
    );

    _categories.add(category);
    notifyListeners();
    return category;
  }

  void reorderCategory(int oldIndex, int newIndex) {
    final category = _categories.removeAt(oldIndex);
    _categories.insert(newIndex, category);
    notifyListeners();
  }

  CategoryModel updateCategory(
      int categoryIndex, String name, Color selectedColor) {
    final category = _categories.removeAt(categoryIndex);
    final updatedCategory = category.copyWith(
      name: name,
      colorCode: selectedColor.value,
      updatedAt: DateTime.now(),
    );
    _categories.insert(categoryIndex, updatedCategory);
    notifyListeners();
    return updatedCategory;
  }

  CategoryModel? findCategory(String id) {
    return categories.where((category) => category.categoryId == id).first;
  }
}
