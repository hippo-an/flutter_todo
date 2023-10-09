import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_todo/common/colors.dart';
import 'package:todo_todo/common/enums.dart';
import 'package:todo_todo/common/tools.dart';
import 'package:todo_todo/core/models/category_model.dart';
import 'package:todo_todo/core/services/repository/category_repository.dart';

final now = DateTime.now();

class CategoryListProvider extends ChangeNotifier {
  final CategoryRepository categoryRepository;
  late List<CategoryModel> _categories = [
    CategoryModel(
      categoryId: uuid.generate(),
      name: 'All',
      colorCode: kDefaultColor.value,
      createdAt: now,
      updatedAt: now,
      isDefault: true,
    )
  ];
  late CategoryModel _selectedCategory;

  bool _isLoading = false;
  CategoryListProvider(this.categoryRepository) {
    _categories = [
      CategoryModel(
        categoryId: uuid.generate(),
        name: 'All',
        colorCode: kDefaultColor.value,
        createdAt: now,
        updatedAt: now,
        isDefault: true,
      ),
    ];

    _selectedCategory = _categories[0];
  }

  Future<void> initData() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove('isInitializeData');
    final isInitializeData = sharedPreferences.getBool('isInitializeData');

    if (isInitializeData == null || !isInitializeData ) {
      final now = DateTime.now();
      final category = CategoryModel(
        categoryId: uuid.generate(),
        name: 'All',
        colorCode: kDefaultColor.value,
        createdAt: now,
        updatedAt: now,
        isDefault: true,
      );
      await categoryRepository.initData(category);
      sharedPreferences.setBool('isInitializeData', true);
    }

    _categories = await categoryRepository.fetchCategories();
    _selectedCategory = _categories[0];
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
    return List<CategoryModel>.unmodifiable(_categories
        .where((category) =>
            !category.isDeleted && category.categoryState == CategoryState.seen)
        .toList());
  }

  List<CategoryModel> get seenCategoriesWithoutDefault {
    return List<CategoryModel>.unmodifiable(_categories
        .where((category) =>
            !category.isDefault &&
            !category.isDeleted &&
            category.categoryState == CategoryState.seen)
        .toList());
  }

  CategoryModel get selectedCategory => _selectedCategory!;

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
      name: name,
      colorCode: kDefaultColor.value,
      createdAt: now,
      updatedAt: now,
    );

    await categoryRepository.createCategory(category: category);
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
    } else if (selectedCategory.categoryId == updatedCategory.categoryId) {
      _selectedCategory = updatedCategory;
    }

    notifyListeners();
  }

  CategoryModel findCategory(String id) {
    return categories.firstWhere(
      (category) => category.categoryId == id,
    );
  }

  void deleteCategory(CategoryModel category) {
    _categories.remove(category);
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
