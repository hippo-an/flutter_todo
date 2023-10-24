import 'package:flutter/material.dart';
import 'package:todo_todo/colors.dart';
import 'package:todo_todo/common/firestore_exception.dart';
import 'package:todo_todo/models/category_model.dart';
import 'package:todo_todo/repository/auth_repository.dart';
import 'package:todo_todo/repository/category_repository.dart';
import 'package:todo_todo/utils.dart';

class CategoryController extends ChangeNotifier {
  final AuthRepository _authRepository;
  final CategoryRepository _categoryRepository;

  CategoryController({
    required AuthRepository authRepository,
    required CategoryRepository categoryRepository,
  })  : _authRepository = authRepository,
        _categoryRepository = categoryRepository;

  Future<void> createCategory(String name) async {
    try {
      final now = DateTime.now();
      final category = CategoryModel(
        categoryId: uuid.generate(),
        userId: _authRepository.currentUser.uid,
        name: name,
        colorCode: kDefaultCategoryColorSet[0].value,
        createdAt: now,
        updatedAt: now,
      );

      await _categoryRepository.createCategory(category: category);
      notifyListeners();
    } on FirestoreException catch (e) {}
  }
}
