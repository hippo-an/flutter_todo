import 'package:flutter/material.dart';
import 'package:todo_todo/models/category_model.dart';

class SelectedCategoryProvider extends ChangeNotifier {
  CategoryModel? _selectedCategory;

  CategoryModel? get selectedCategory => _selectedCategory;

  void updateSelectedCategory(CategoryModel? selectedCategory) {
    _selectedCategory = selectedCategory;
    notifyListeners();
  }
}
