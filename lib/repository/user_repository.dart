import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_todo/common/firestore_exception.dart';
import 'package:todo_todo/models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore;

  UserRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  Future<void> createUser(UserModel user) async {
    try {
      await _firestore
          .collection('users')
          .doc(user.userId)
          .set(user.toJson());
    } catch (e) {
      throw FirestoreException(message: e.toString());
    }
  }
  Future<void> validateUsername(String username) async {
    if ((await _firestore
        .collection('users')
        .where('username', isEqualTo: username)
        .get()).size > 0) {
      throw FirestoreException(message: 'Username is already using..');
    }
  }
}
