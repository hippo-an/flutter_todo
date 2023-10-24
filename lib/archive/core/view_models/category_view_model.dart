import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_todo/archive/locator.dart';
import 'package:todo_todo/archive/common/colors.dart';
import 'package:todo_todo/archive/common/enums.dart';
import 'package:todo_todo/archive/common/tools.dart';
import 'package:todo_todo/models/category_model.dart';
import 'package:todo_todo/archive/core/services/repository/category_repository.dart';
import 'package:todo_todo/archive/core/view_models/auth_view_model.dart';

class CategoryViewModel extends ChangeNotifier {
  final CategoryRepository _categoryRepository;
  final AuthViewModel _authViewModel;
  final List<CategoryModel> _categories = [];
  CategoryModel? _selectedCategory;
  bool _isLoading;

  CategoryViewModel()
      : _categoryRepository = locator<CategoryRepository>(),
        _authViewModel = locator<AuthViewModel>(),
        _isLoading = false;

  Future<void> init() async {
    if (_categories.isEmpty) {
      await fetchCategories();
    }

    if (_categories.isNotEmpty && _selectedCategory == null) {
      _selectedCategory = _categories[0];
    }
    notifyListeners();
  }

  Future<void> initCategoryForUserSignUp() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final isInitializeData = sharedPreferences.getBool('isInitializeData');

    if (isInitializeData == null || !isInitializeData) {
      final now = DateTime.now();

      final category = CategoryModel(
        categoryId: uuid.generate(),
        userId: _authViewModel.currentUserId,
        name: 'All',
        colorCode: kCategoryDefaultColor.value,
        createdAt: now,
        updatedAt: now,
        isDefault: true,
      );
      await _categoryRepository.createCategory(category: category);
      await fetchCategories();
      updateSelectedCategoryToDefault();
      await sharedPreferences.setBool('isInitializeData', true);
    }
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    _categories.clear();
    final categories =
        await _categoryRepository.fetchCategories(_authViewModel.currentUserId);
    _categories.addAll(categories);
  }

  List<CategoryModel> get categoriesWithoutDefault {
    final ret = List<CategoryModel>.from(_categories
        .where((category) => !category.isDefault && !category.isDeleted)
        .toList());

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

  List<CategoryModel> get seenCategories {
    return List<CategoryModel>.unmodifiable(
      _categories
          .where((category) =>
              !category.isDeleted &&
              category.categoryState == CategoryState.seen)
          .toList(),
    );
  }

  List<CategoryModel> get seenCategoriesWithoutDefault {
    return List<CategoryModel>.unmodifiable(_categories
        .where((category) =>
            !category.isDefault &&
            !category.isDeleted &&
            category.categoryState == CategoryState.seen)
        .toList());
  }

  CategoryModel? get selectedCategory => _selectedCategory;

  bool get isLoading => _isLoading;

  CategoryModel get defaultCategory => _categories[0];

  get totalCount => _categories
      .where((c) => !c.isDeleted)
      .map((e) => e.taskCount)
      .reduce((a, b) => a + b);

  Future<CategoryModel> createCategory(String name) async {
    final now = DateTime.now();
    final category = CategoryModel(
      categoryId: uuid.generate(),
      userId: _authViewModel.currentUserId,
      name: name,
      colorCode: kCategoryDefaultColor.value,
      createdAt: now,
      updatedAt: now,
    );

    await _categoryRepository.createCategory(category: category);
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

  void updateCategory(
    String categoryId, {
    String? name,
    Color? colorCode,
    CategoryState? categoryState,
    int task = 0,
  }) {
    final category =
        _categories.firstWhere((category) => category.categoryId == categoryId);
    final index = _categories.indexOf(category);
    final updatedCategory = _categories.removeAt(index).copyWith(
          name: name ?? category.name,
          colorCode: colorCode?.value ?? category.colorCode,
          taskCount: category.taskCount + task,
          categoryState: categoryState ?? category.categoryState,
          updatedAt: DateTime.now(),
        );
    _categories.insert(index, updatedCategory);

    if (updatedCategory.categoryState == CategoryState.hide) {
      _selectedCategory = _categories[0];
    } else if (selectedCategory?.categoryId == updatedCategory.categoryId) {
      _selectedCategory = updatedCategory;
    }

    notifyListeners();
  }

  CategoryModel findCategory(String id) {
    return categories.firstWhere(
      (category) => category.categoryId == id,
    );
  }

  void deleteCategory(CategoryModel category) async {
    await _categoryRepository.deleteCategory(category);
    await fetchCategories();
    notifyListeners();
  }

  void updateSelectedCategory(CategoryModel selectedCategory) {
    _selectedCategory = selectedCategory;
    notifyListeners();
  }

  void updateSelectedCategoryToDefault() {
    _selectedCategory = _categories[0];
    notifyListeners();
  }
}
