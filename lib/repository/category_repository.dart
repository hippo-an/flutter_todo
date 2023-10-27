import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_todo/common/firestore_exception.dart';
import 'package:todo_todo/enums.dart';
import 'package:todo_todo/models/category_model.dart';

class CategoryRepository {
  final FirebaseFirestore _firestore;

  CategoryRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  Future<void> createCategory({required CategoryModel category}) async {
    try {
      await _firestore
          .collection('categories')
          .doc(category.categoryId)
          .set(category.toJson());
    } catch (e) {
      throw FirestoreException(message: e.toString());
    }
  }

  Future<List<CategoryModel>> fetchCategory(String uid) async {
    try {
      final snap = await _firestore
          .collection('categories')
          .where('userId', isEqualTo: uid)
          .get();

      if (snap.docs.isNotEmpty) {
        return snap.docs
            .map(
              (e) => CategoryModel.fromJson(
                e.data(),
              ),
            )
            .toList();
      }

      return [];
    } catch (e) {
      throw FirestoreException(message: e.toString());
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    try {
      await _firestore.collection('categories').doc(categoryId).delete();
    } catch (e) {
      throw FirestoreException(message: e.toString());
    }
  }

  Future<void> changeCategoryStar(String categoryId, bool isStared) async {
    try {
      await _firestore.collection('categories').doc(categoryId).update({
        'isStared': !isStared,
        'updatedAt': DateTime.now().toString(),
      });
    } catch (e) {
      throw FirestoreException(message: e.toString());
    }
  }

  Future<void> changeHide(
      String categoryId, CategoryState categoryState) async {
    try {
      await _firestore.collection('categories').doc(categoryId).update({
        'categoryState': categoryState.name,
        'updatedAt': DateTime.now().toString(),
      });
    } catch (e) {
      throw FirestoreException(message: e.toString());
    }
  }

  Future<void> updateCategory(
      String categoryId, String name, int colorCode) async {
    try {
      await _firestore.collection('categories').doc(categoryId).update({
        'name': name,
        'colorCode': colorCode,
        'updatedAt': DateTime.now().toString(),
      });
    } catch (e) {
      throw FirestoreException(message: e.toString());
    }
  }

  Future<void> taskCountIncrease({required String categoryId, required int value}) async {
    try {
      await _firestore.collection('categories').doc(categoryId).update({
        'taskCount': FieldValue.increment(value),
        'updatedAt': DateTime.now().toString(),
      });
    } catch (e) {
      throw FirestoreException(message: e.toString());
    }
  }

  Future<CategoryModel> category(String categoryId) async {
    try {
      final snap = await _firestore.collection('categories').doc(categoryId).get();
      return CategoryModel.fromJson(snap.data()!);
    } catch (e) {
      throw FirestoreException(message: e.toString());
    }
  }
}
