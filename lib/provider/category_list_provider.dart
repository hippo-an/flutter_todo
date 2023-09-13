import 'package:flutter/material.dart';
import 'package:todo_todo/models/category_model.dart';
import 'package:uuid/v4.dart';

const uuid = UuidV4();

class CategoryListProvider extends ChangeNotifier {
  final List<CategoryModel> _categories = [];

  List<CategoryModel> get categories => _categories;

  CategoryModel createCategory(String name) {
    final category = CategoryModel(
      id: uuid.generate(),
      name: name,
      color: Colors.lightBlueAccent,
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


  CategoryModel updateCategory(int categoryIndex, String name, Color selectedColor) {
    final category = _categories.removeAt(categoryIndex);
    final updatedCategory = category.copyWith(name: name, color: selectedColor, updatedAt: DateTime.now());
    _categories.insert(categoryIndex, updatedCategory);
    notifyListeners();
    return updatedCategory;
  }

  CategoryModel? findCategory(String id) {
    return categories.where((category) => category.id == id).first;
  }

}