import 'package:flutter/material.dart';
import 'package:todo_todo/archive/core/models/user_model.dart';
import 'package:todo_todo/common/auth_exception.dart';
import 'package:todo_todo/common/firestore_exception.dart';
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

  AuthController({
    required AuthRepository authRepository,
    required UserRepository firestoreRepository,
  })  : _authRepository = authRepository,
        _userRepository = firestoreRepository;

  Future<bool> signOut() async {
    try {
      await _authRepository.signOut();
      return true;
    } on AuthException catch (e) {
      print(e.message);
      return false;
    }
  }

  // Future<({bool success, String? message})> signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleUser =
  //         await locator<GoogleSignIn>().signIn();
  //
  //     final GoogleSignInAuthentication? googleAuth =
  //         await googleUser?.authentication;
  //
  //     if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
  //       final credential = GoogleAuthProvider.credential(
  //         accessToken: googleAuth?.accessToken,
  //         idToken: googleAuth?.idToken,
  //       );
  //
  //       UserCredential userCredential =
  //           await _authViewModel.signInWithCredential(credential);
  //
  //       if (userCredential.user != null) {
  //         if (userCredential.additionalUserInfo!.isNewUser) {
  //           await _initializeUser(userCredential);
  //           return (success: true, message: 'Email verification sent.');
  //         }
  //
  //         return (success: true, message: null);
  //       }
  //     }
  //
  //     return (
  //       success: false,
  //       message: 'Something went wrong in sign in process..',
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     return (
  //       success: false,
  //       message: e.message ?? 'Something went wrong in sign in process...',
  //     );
  //   }
  // }

  // Future<({bool success, String? message})> signInWithEmailAndPassword(
  //     {required String email, required String password}) async {
  //   try {
  //     final userCredential = await _authViewModel.signInWithEmailAndPassword(
  //         email: email, password: password);
  //
  //     if (userCredential.user != null) {
  //       return (success: true, message: null);
  //     }
  //     return (
  //       success: false,
  //       message: 'Something went wrong in sign in process..',
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     return (
  //       success: false,
  //       message: switch (e.code) {
  //         'user-not-found' => 'Check your email and password',
  //         'wrong-password' => 'Check your email and password',
  //         _ => 'Check your email and password.',
  //       },
  //     );
  //   }
  // }

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
    );
  }

  void _validate(_Field field, String value, bool Function(String val) validate) {
    if (!validate(value)) {
      throw AuthException(message: '${field.name} is invalid. Check it again.');
    }
  }
}
