import 'package:flutter/material.dart';
import 'package:todo_todo/colors.dart';
import 'package:todo_todo/common/firestore_exception.dart';
import 'package:todo_todo/enums.dart';
import 'package:todo_todo/models/category_model.dart';
import 'package:todo_todo/repository/auth_repository.dart';
import 'package:todo_todo/repository/category_repository.dart';
import 'package:todo_todo/utils.dart';

const _names = [
  'All',
  'Workout',
  'Business',
  'Study',
];

class CategoryController extends ChangeNotifier {
  final AuthRepository _authRepository;
  final CategoryRepository _categoryRepository;

  CategoryController({
    required AuthRepository authRepository,
    required CategoryRepository categoryRepository,
  })  : _authRepository = authRepository,
        _categoryRepository = categoryRepository;

  List<CategoryModel> _categories = [];

  List<CategoryModel> get categories => _categories.toList();

  List<CategoryModel> get categoriesWithoutDefault =>
      _categories.where((category) => !category.isDefault).toList();

  List<CategoryModel> get staredCategories => _categories
      .where((category) => !category.isDefault && category.isStared)
      .toList();

  Future<bool> createCategory(BuildContext context, String name) async {
    try {
      final category = _createCategory(
        uid: _authRepository.currentUser.uid,
        name: name,
        sortNumber: _categories.length,
      );

      await _categoryRepository.createCategory(category: category);
      return true;
    } on FirestoreException catch (e) {
      showSnackBar(context, e.toString());
      return false;
    } finally {
      await _fetchCategories();
      notifyListeners();
    }
  }

  Future<void> initializeForUser(String uid) async {
    final categories = List<CategoryModel>.generate(
      _names.length,
      (index) => _createCategory(
          uid: uid,
          name: _names[index],
          isDefault: _names[index] == _names[0],
          sortNumber: index),
    );

    for (CategoryModel category in categories) {
      try {
        await _categoryRepository.createCategory(category: category);
      } catch (e) {}
    }

    await _fetchCategories();
    notifyListeners();
  }

  Future<void> fetchCategoriesForInit() async {
    await _fetchCategories();
    notifyListeners();
  }

  Future<void> deleteCategory(BuildContext context, String categoryId) async {
    try {
      await _categoryRepository.deleteCategory(categoryId);
    } on FirestoreException catch (e) {
      showSnackBar(context, e.toString());
    } finally {
      await _fetchCategories();
      notifyListeners();
    }
  }

  Future<void> changeCategoryStar(
      BuildContext context, String categoryId, bool isStared) async {
    try {
      await _categoryRepository.changeCategoryStar(categoryId, isStared);
    } on FirestoreException catch (e) {
      showSnackBar(context, e.toString());
    } finally {
      await _fetchCategories();
      notifyListeners();
    }
  }

  Future<void> changeHide(
    BuildContext context,
    String categoryId,
    CategoryState categoryState,
  ) async {
    try {
      await _categoryRepository.changeHide(
        categoryId,
        categoryState == CategoryState.seen
            ? CategoryState.hide
            : CategoryState.seen,
      );
    } on FirestoreException catch (e) {
      showSnackBar(context, e.toString());
    } finally {
      await _fetchCategories();
      notifyListeners();
    }
  }

  Future<bool> updateCategory(
    BuildContext context,
    String categoryId,
    String name,
    Color selectedColor,
  ) async {
    try {
      await _categoryRepository.updateCategory(
        categoryId,
        name,
        selectedColor.value,
      );

      return true;
    } on FirestoreException catch (e) {
      showSnackBar(context, e.toString());
      return false;
    } finally {
      await _fetchCategories();
      notifyListeners();
    }
  }

  CategoryModel _createCategory({
    required String uid,
    required String name,
    required int sortNumber,
    bool? isDefault,
  }) {
    final now = DateTime.now();
    return CategoryModel(
      categoryId: uuid.generate(),
      userId: uid,
      name: name,
      colorCode: kDefaultCategoryColorSet[0].value,
      sortNumber: sortNumber,
      createdAt: now,
      updatedAt: now,
      isDefault: isDefault ?? false,
    );
  }

  Future<void> _fetchCategories() async {
    try {
      _categories = await _categoryRepository
          .fetchCategory(_authRepository.currentUser.uid);

      _categories.sort(
        (a, b) => a.sortNumber - b.sortNumber,
      );
    } catch (e) {}
  }
}