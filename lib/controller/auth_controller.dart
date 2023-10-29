import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_todo/colors.dart';
import 'package:todo_todo/common/auth_exception.dart';
import 'package:todo_todo/common/firestore_exception.dart';
import 'package:todo_todo/constants.dart';
import 'package:todo_todo/controller/category_controller.dart';
import 'package:todo_todo/models/user_model.dart';
import 'package:todo_todo/repository/auth_repository.dart';
import 'package:todo_todo/repository/user_repository.dart';
import 'package:todo_todo/utils.dart';

enum _Field {
  email,
  password,
  username,
}

class AuthController extends ChangeNotifier {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final CategoryController _categoryController;

  AuthController({
    required AuthRepository authRepository,
    required UserRepository firestoreRepository,
    required CategoryController categoryController,
  })  : _authRepository = authRepository,
        _userRepository = firestoreRepository,
        _categoryController = categoryController;

  Future<bool> signOut(BuildContext context) async {
    try {
      await _authRepository.signOut();
      return true;
    } on AuthException catch (e) {
      showSnackBar(context, 'Logout Error!');
      return false;
    }
  }

  Future<bool> loginWithGoogle({
    required BuildContext context,
  }) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
        final email = googleUser!.email;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth!.accessToken,
          idToken: googleAuth.idToken,
        );

        return await _authRepository.loginWithGoogle(credential).then(
          (userCredential) async {
            if (userCredential.user != null) {
              if (userCredential.additionalUserInfo!.isNewUser) {
                await _userRepository.createUser(
                  _createUser(
                    userCredential.user!.uid,
                    email,
                    uuidV4.generate(),
                  ),
                );

                await _categoryController.initializeForUser(
                  userCredential.user!.uid,
                );
              }

              return true;
            }

            return false;
          },
        );
      }

      return false;
    } on AuthException catch (e) {
      showSnackBar(context, e.message);
      return false;
    } on FirestoreException catch (e) {
      showSnackBar(context, e.message);
      return false;
    }
  }

  Future<bool> loginWithEmail({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      _validate(_Field.email, email, _emailValidate);
      _validate(_Field.password, password, _passwordValidate);
      return await _authRepository
          .loginWithEmail(
        email: email,
        password: password,
      )
          .then((userCredential) {
        return userCredential.user != null;
      });
    } on AuthException catch (e) {
      showSnackBar(context, e.message);
      return false;
    }
  }

  Future<bool> signUpWithEmailAndPassword({
    required BuildContext context,
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      _validate(_Field.email, email, _emailValidate);
      _validate(_Field.password, password, _passwordValidate);
      _validate(_Field.username, username, _usernameValidate);

      await _userRepository.validateUsername(username);

      return await _authRepository
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then(
        (userCredential) async {
          await _authRepository.signOut();

          if (userCredential.user != null) {
            await _userRepository.createUser(
              _createUser(
                userCredential.user!.uid,
                email,
                username,
              ),
            );

            await _categoryController.initializeForUser(
              userCredential.user!.uid,
            );

            return true;
          }

          return false;
        },
      );
    } on AuthException catch (e) {
      showSnackBar(context, e.message);
      return false;
    } on FirestoreException catch (e) {
      showSnackBar(context, e.message);
      return false;
    }
  }

  bool _emailValidate(String email) {
    if (email.isEmpty || email.length < 4) {
      return false;
    }

    if (!email.contains('@')) {
      return false;
    }

    return true;
  }

  bool _passwordValidate(String password) {
    if (password.isEmpty || password.length < 8) {
      return false;
    }

    return true;
  }

  bool _usernameValidate(String username) {
    if (username.isEmpty || username.length < 4) {
      return false;
    }

    return true;
  }

  UserModel _createUser(String uid, String email, String username) {
    final now = DateTime.now();

    return UserModel(
      userId: uid,
      identity: email,
      username: username,
      createdAt: now,
      updatedAt: now,
      colorCode: kDefaultCategoryColorSet[0].value,
    );
  }

  void _validate(
      _Field field, String value, bool Function(String val) validate) {
    if (!validate(value)) {
      throw AuthException(message: '${field.name} is invalid. Check it again.');
    }
  }
}
