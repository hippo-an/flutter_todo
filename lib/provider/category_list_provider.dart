import 'package:flutter/material.dart';
import 'package:todo_todo/consts/enums.dart';
import 'package:todo_todo/consts/tools.dart';
import 'package:todo_todo/models/category_model.dart';

class CategoryListProvider extends ChangeNotifier {
  final List<CategoryModel> _categories = [];
  bool _isLoading = false;

  List<CategoryModel> get categories {
    final ret = List<CategoryModel>.from(
        _categories.where((category) => !category.isDeleted).toList());

    ret.sort((a, b) {
      if (a.categoryState == CategoryState.activated &&
          b.categoryState == CategoryState.deactivated) {
        return 0;
      } else if (a.categoryState == CategoryState.deactivated &&
          b.categoryState == CategoryState.activated) {
        return 1;
      }
      return 0;
    });
    return ret;
  }

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
    if (category.categoryState == CategoryState.activated) {
      _categories.insert(newIndex, category);
      notifyListeners();
    }
  }

  CategoryModel updateCategory(
      CategoryModel categoryModel, String name, Color selectedColor) {
    final index = _categories.indexOf(categoryModel);
    final updatedCategory = _categories.removeAt(index).copyWith(
      name: name,
      colorCode: selectedColor.value,
      updatedAt: DateTime.now(),
    );
    _categories.insert(index, updatedCategory);
    notifyListeners();
    return updatedCategory;
  }

  CategoryModel? findCategory(String id) {
    return categories.firstWhere((category) => category.categoryId == id);
  }

  void deleteCategory(CategoryModel category) {
    _categories.remove(category);
    notifyListeners();
  }

  void updateCategoryState(CategoryModel category) {
    final index = _categories.indexOf(category);
    ;
    _categories.insert(
        index,
        _categories.removeAt(index).copyWith(
              categoryState: category.categoryState == CategoryState.activated
                  ? CategoryState.deactivated
                  : CategoryState.activated,
            ));

    notifyListeners();
  }
}
