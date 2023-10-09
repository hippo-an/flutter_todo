import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_todo/core/view_models/sign_up_view_model.dart';
import 'package:todo_todo/locator.dart';

class AuthService {
  late final FirebaseAuth _firebaseAuth;
  late final SignUpViewModel _signUpViewModel;

  AuthService()
      : _firebaseAuth = FirebaseAuth.instance,
        _signUpViewModel = locator<SignUpViewModel>();

  Stream<User?> get streamUser => _firebaseAuth.authStateChanges();

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {}
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
            await _firebaseAuth.signInWithCredential(credential);

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
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
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
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        await _initializeUser(userCredential);
        await _createUser(userCredential);
        await _firebaseAuth.currentUser?.sendEmailVerification();
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
      await _createUser(userCredential);
      await _createCategory();
      await _firebaseAuth.currentUser?.sendEmailVerification();
    } catch (e) {

    }
  }

  Future<void> _createUser(UserCredential credential) async {
    final user = credential.user;
    await _signUpViewModel.createUser(user!.uid, user.email!);
  }

  Future<void> _createCategory() async {
    // TODO 카테고리 생성
  }
}
