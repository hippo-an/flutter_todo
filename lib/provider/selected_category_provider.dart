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
  List<CategoryModel> _cacheCategory = [];

  int get selectedIndex => _selectedIndex;

  List<CategoryModel> get categories {
    return [_baseCategory, ..._categories];
  }

  void createCategory(String name) {
    final category = CategoryModel(
      id: uuid.generate(),
      name: name,
      color: Colors.lightBlueAccent,
    );

    _categories.add(category);
    notifyListeners();
  }

  void updateSelectedIndex(int selectedIndex) {
    _selectedIndex = selectedIndex;
    notifyListeners();
  }
}
