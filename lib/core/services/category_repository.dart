import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_todo/core/models/category_model.dart';

class CategoryRepository {
  Future<void> createCategory({
    required CategoryModel category,
  }) async {
    await FirebaseFirestore.instance
        .collection('categories')
        .doc(category.categoryId)
        .set(category.toJson());
  }

  Future<void> initData(CategoryModel category) async {
    await FirebaseFirestore.instance
        .collection('categories')
        .doc(category.categoryId)
        .set(category.toJson());
  }

  Future<List<CategoryModel>> fetchCategories() async {
    final response =
        await FirebaseFirestore.instance.collection('categories').get();

    return response.docs
        .map(
          (e) => CategoryModel.fromJson(
            e.data(),
          ),
        )
        .toList();
  }
}
