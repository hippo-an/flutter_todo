import 'package:flutter/material.dart';
import 'package:todo_todo/consts/enums.dart';
import 'package:todo_todo/consts/tools.dart';
import 'package:todo_todo/models/category_model.dart';

class CategoryListProvider extends ChangeNotifier {
  final List<CategoryModel> _categories = [];
  bool _isLoading = false;

  List<CategoryModel> get categories => List.unmodifiable(
      _categories.where((category) => !category.isDeleted).toList());

  List<CategoryModel> get activatedCategories => List.unmodifiable(_categories
      .where((category) =>
          !category.isDeleted &&
          category.categoryState == CategoryState.activated)
      .toList());

  bool get isLoading => _isLoading;

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
    return categories.firstWhere((category) => category.categoryId == id);
  }
}
