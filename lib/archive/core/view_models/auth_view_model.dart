import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_todo/archive/locator.dart';
import 'package:todo_todo/archive/core/models/user_model.dart';
import 'package:todo_todo/archive/core/services/repository/user_repository.dart';

class AuthViewModel extends ChangeNotifier {
  late final UserRepository _userRepository;
  final FirebaseAuth _firebaseAuth;

  AuthViewModel()
      : _firebaseAuth = FirebaseAuth.instance,
        _userRepository = locator<UserRepository>();


  Stream<User?> get streamUser => _firebaseAuth.authStateChanges();

  String get currentUserId => _firebaseAuth.currentUser!.uid;

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {

    }
  }

  Future<void> createUser(String uid, String identity) async {
    await _userRepository.createUser(
      UserModel(
        userId: uid,
        identity: identity,
        createdAt: DateTime.now(), username: '', updatedAt: DateTime.now(),
      ),
    );
  }

  Future<UserCredential> signInWithCredential(OAuthCredential credential) async {
    return await _firebaseAuth.signInWithCredential(credential);
  }

  Future<UserCredential> createUserWithEmailAndPassword({required String email, required String password}) async{
    return await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> signInWithEmailAndPassword({required String email, required String password}) async{
    return await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> sendVerificationEmail() async {
    await _firebaseAuth.currentUser?.sendEmailVerification();
  }
}
