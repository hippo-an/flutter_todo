import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_todo/archive/core/models/user_model.dart';

class UserRepository {
  Future<UserModel> fetchUserById(String uid) async {
    final response =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    return UserModel.fromJson(response.data()!);
  }

  Future<void> createUser(UserModel userModel) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.userId)
        .set(userModel.toJson());
  }
}
