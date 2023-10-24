import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_todo/common/auth_exception.dart';

class AuthRepository {
  final FirebaseAuth _auth;

  AuthRepository({
    required FirebaseAuth auth,
  }) : _auth = auth;

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: e.message);
    }
  }

  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: e.message);
    }
  }
}
