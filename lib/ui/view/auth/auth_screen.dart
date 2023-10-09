import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/core/view_models/user_provider.dart';
import 'package:todo_todo/ui/view/auth/sign_up_screen.dart';

final _auth = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _isGoogleLoading = false;
  bool _isEmailLoading = false;
  bool _isFacebookLoading = false;
  bool _obscure = true;

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signWithGoogle(BuildContext context) async {
    try {
      setState(() {
        _isGoogleLoading = true;
      });

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        print(userCredential.user?.providerData
            .map((e) => e.providerId)
            .toList()
            .toString());

        if (userCredential.user != null) {
          if (userCredential.additionalUserInfo!.isNewUser) {
            // initialize data
            _createUser(userCredential);
            _createCategory();
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        _passwordController.clear();
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            SnackBar(
              content: Text(e.message!),
            ),
          );
      }
    } finally {
      setState(() {
        _isGoogleLoading = false;
      });
    }
  }

  Future<void> _loginWithEmail() async {
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      if (email.isEmpty) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            const SnackBar(
              content: Text('Fill the Email.'),
            ),
          );
        return;
      }

      if (email.length < 4 || !email.contains('@')) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            const SnackBar(
              content: Text('Invalid Email'),
            ),
          );
        return;
      }

      if (password.isEmpty) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            const SnackBar(
              content: Text('Fill the Password'),
            ),
          );
        return;
      }

      setState(() {
        _isEmailLoading = true;
      });

      final userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (userCredential.user?.emailVerified ?? false) {
        if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        } else {}
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              const SnackBar(
                content: Text('Verify your email first.'),
              ),
            );
        }
      }
    } on FirebaseAuthException catch (e) {
      final message = switch (e.code) {
        'user-not-found' => 'Check your email and password',
        'wrong-password' => 'Check your email and password',
        _ => 'Check your email and password.',
      };

      _passwordController.clear();

      if (context.mounted) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            SnackBar(
              content: Text(message),
            ),
          );
      }
    } finally {
      setState(() {
        _isEmailLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    var width = MediaQuery.of(context).size.width;
    var actionPossible =
        _isGoogleLoading || _isEmailLoading || _isFacebookLoading;
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/landing_background_image.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: const Center(
                    child: Text(
                      'Todo Todo',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        label: Text('Email'),
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 1,
                      maxLength: 30,
                      buildCounter: (context,
                          {required currentLength,
                          required isFocused,
                          maxLength}) {
                        return const SizedBox.shrink();
                      },
                      keyboardType: TextInputType.emailAddress,
                      scrollPadding: EdgeInsets.only(bottom: keyboardSpace),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        label: const Text('Password'),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(_obscure
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _obscure = !_obscure;
                            });
                          },
                        ),
                      ),
                      maxLines: 1,
                      obscureText: _obscure,
                      keyboardType: TextInputType.text,
                      scrollPadding: EdgeInsets.only(bottom: keyboardSpace),
                      maxLength: 30,
                      buildCounter: (context,
                          {required currentLength,
                          required isFocused,
                          maxLength}) {
                        return const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
                const SizedBox(height: 8),
                _isEmailLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: width,
                        child: OutlinedButton.icon(
                          onPressed: actionPossible ? null : _loginWithEmail,
                          icon: const Icon(Icons.login),
                          label: const Text('Login'),
                        ),
                      ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        context.pushNamed(SignUpScreen.routeName);
                      },
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Divider(
                        indent: 40,
                        endIndent: 20,
                      ),
                    ),
                    Text(
                      'or',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    Expanded(
                      child: Divider(
                        indent: 20,
                        endIndent: 40,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _isGoogleLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: width,
                        child: ClipRRect(
                          clipBehavior: Clip.hardEdge,
                          borderRadius: BorderRadius.circular(20),
                          child: SignInButton(
                            Buttons.Google,
                            text: 'Start with Google',
                            onPressed: actionPossible
                                ? () {}
                                : () {
                                    _signWithGoogle(context);
                                  },
                          ),
                        ),
                      ),
                const SizedBox(height: 8),
                SizedBox(
                  width: width,
                  child: ClipRRect(
                    clipBehavior: Clip.hardEdge,
                    borderRadius: BorderRadius.circular(20),
                    child: SignInButton(
                      Buttons.Facebook,
                      text: 'Start with Facebook',
                      onPressed: actionPossible ? () {} : () {},
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _createUser(UserCredential credential) {
    context
        .read<UserProvider>()
        .createUser(credential.user!.uid, credential.user!.email!);
  }

  void _createCategory() {
  }
}
