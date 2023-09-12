import 'package:flutter/material.dart';
import 'package:todo_todo/models/category_model.dart';
import 'package:uuid/v4.dart';

const uuid = UuidV4();

// const _baseCategory = 'All';
final _baseCategory = CategoryModel(
  id: uuid.generate(),
  name: 'All',
  color: Colors.lightBlueAccent,
);

class CategoryProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  final List<CategoryModel> _categories = [];

  int get selectedIndex => _selectedIndex;

  List<CategoryModel> get categories => [_baseCategory, ..._categories];
  List<CategoryModel> get categoriesWithoutAll => [..._categories];

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

  void updateSelectedIndex(int selectedIndex) {
    _selectedIndex = selectedIndex;
    notifyListeners();
  }

  void reorderCategory(int oldIndex, int newIndex) {
    final category = _categories.removeAt(oldIndex);
    _categories.insert(newIndex, category);
    notifyListeners();
  }

  void updateCategory(int categoryIndex, String name, Color selectedColor) {
    final category = _categories.removeAt(categoryIndex);
    final newCategory = category.copyWith(name: name, color: selectedColor, updatedAt: DateTime.now());
    _categories.insert(categoryIndex, newCategory);
    notifyListeners();
  }

  CategoryModel? findCategory(String id) {
    return categories.where((category) => category.id == id).first;
  }
}
