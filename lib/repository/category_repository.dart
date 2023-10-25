import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_todo/common/firestore_exception.dart';
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
}
