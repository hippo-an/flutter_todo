import 'package:flutter/material.dart';
import 'package:todo_todo/consts/enums.dart';
import 'package:todo_todo/consts/tools.dart';
import 'package:todo_todo/models/category_model.dart';

class CategoryListProvider extends ChangeNotifier {
  final List<CategoryModel> _categories = [];
  CategoryModel? _selectedCategory;
  bool _isLoading = false;

  List<CategoryModel> get categories {
    final ret = List<CategoryModel>.from(
        _categories.where((category) => !category.isDeleted).toList());

    ret.sort((a, b) {
      if (a.categoryState == CategoryState.seen &&
          b.categoryState == CategoryState.hide) {
        return 0;
      } else if (a.categoryState == CategoryState.hide &&
          b.categoryState == CategoryState.seen) {
        return 1;
      }
      return 0;
    });
    return ret;
  }

  List<CategoryModel> get activatedCategories {
    return List<CategoryModel>.unmodifiable(_categories
        .where((category) =>
            !category.isDeleted && category.categoryState == CategoryState.seen)
        .toList());
  }

  CategoryModel? get selectedCategory => _selectedCategory;

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
    if (category.categoryState == CategoryState.seen) {
      _categories.insert(newIndex, category);
      notifyListeners();
    }
  }

  void updateCategory(String categoryId,
      {String? name,
      Color? colorCode,
      CategoryState? categoryState,
      int task = 0,
      int complete = 0}) {
    final category =
        _categories.firstWhere((category) => category.categoryId == categoryId);
    final index = _categories.indexOf(category);
    final updatedCategory = _categories.removeAt(index).copyWith(
          name: name ?? category.name,
          colorCode: colorCode?.value ?? category.colorCode,
          taskCount: category.taskCount + task,
          completeCount: category.completeCount + complete,
          categoryState: categoryState ?? category.categoryState,
          updatedAt: DateTime.now(),
        );
    _categories.insert(index, updatedCategory);

    if (updatedCategory.categoryState == CategoryState.hide) {
      _selectedCategory = null;
    } else if (selectedCategory?.categoryId == updatedCategory.categoryId) {
      _selectedCategory = updatedCategory;
    }

    notifyListeners();
  }

  CategoryModel? findCategory(String? id) {
    return categories.firstWhere((category) => category.categoryId == id);
  }

  void deleteCategory(CategoryModel category) {
    _categories.remove(category);
    notifyListeners();
  }

  void updateSelectedCategory(CategoryModel? selectedCategory) {
    _selectedCategory = selectedCategory;
    notifyListeners();
  }
}
