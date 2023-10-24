import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_todo/archive/core/services/category_service.dart';
import 'package:todo_todo/archive/core/view_models/auth_view_model.dart';
import 'package:todo_todo/archive/locator.dart';

class AuthService {
  final AuthViewModel _authViewModel;
  final CategoryService _categoryService;


  AuthService()
      : _authViewModel = locator<AuthViewModel>(),
        _categoryService = locator<CategoryService>();

  Stream<User?> get streamUser => _authViewModel.streamUser;

  String get currentUserId => _authViewModel.currentUserId;

  Future<void> signOut() async {
    await _authViewModel.signOut();
  }

  Future<({bool success, String? message})> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser =
          await locator<GoogleSignIn>().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        UserCredential userCredential =
            await _authViewModel.signInWithCredential(credential);

        if (userCredential.user != null) {
          if (userCredential.additionalUserInfo!.isNewUser) {
            await _initializeUser(userCredential);
            return (success: true, message: 'Email verification sent.');
          }

          return (success: true, message: null);
        }
      }

      return (
        success: false,
        message: 'Something went wrong in sign in process..',
      );
    } on FirebaseAuthException catch (e) {
      return (
        success: false,
        message: e.message ?? 'Something went wrong in sign in process...',
      );
    }
  }

  Future<({bool success, String? message})> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final userCredential = await _authViewModel.signInWithEmailAndPassword(
          email: email, password: password);

      if (userCredential.user != null) {
        return (success: true, message: null);
      }
      return (
        success: false,
        message: 'Something went wrong in sign in process..',
      );
    } on FirebaseAuthException catch (e) {
      return (
        success: false,
        message: switch (e.code) {
          'user-not-found' => 'Check your email and password',
          'wrong-password' => 'Check your email and password',
          _ => 'Check your email and password.',
        },
      );
    }
  }

  Future<({bool success, String? message})> signUpWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final userCredential = await _authViewModel.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        await _initializeUser(userCredential);
        return (success: true, message: 'Email verification sent.');
      }
      return (
        success: false,
        message: 'Something went wrong in sign up process..',
      );
    } on FirebaseAuthException catch (e) {
      return (
        success: false,
        message: e.message ?? 'Authentication failed.',
      );
    }
  }

  Future<void> _initializeUser(UserCredential userCredential) async {
    try {
      final userId = await _createUser(userCredential);
      await _createCategory(userId);
      await _authViewModel.sendVerificationEmail();
    } on Exception catch (e) {
    }
  }

  Future<String> _createUser(UserCredential credential) async {
    final user = credential.user;
    await _authViewModel.createUser(user!.uid, user.email!);
    return user.uid;
  }

  Future<void> _createCategory(String userId) async {
    await _categoryService.initCategoryForUserSignUp();
  }
}
