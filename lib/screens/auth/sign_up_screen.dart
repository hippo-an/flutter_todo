import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/provider/user_provider.dart';

final _auth = FirebaseAuth.instance;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static String routeName = 'sign_up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _isEmailLoading = false;
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

  Future<void> _signUpWithEmail() async {
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

      if (password.length < 8) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            const SnackBar(
              content: Text('Password is too short'),
            ),
          );
        return;
      }

      setState(() {
        _isEmailLoading = true;
      });

      final createUser = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _createUser(createUser);
    } on FirebaseAuthException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            SnackBar(content: Text(error.message ?? 'Authentication failed.')),
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
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        label: Text('Email'),
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 1,
                      keyboardType: TextInputType.emailAddress,
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
                    TextFormField(
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
                _isEmailLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: width,
                        child: ElevatedButton.icon(
                          onPressed: _isEmailLoading ? null : _signUpWithEmail,
                          icon: const Icon(Icons.app_registration),
                          label: const Text('Sign Up'),
                        ),
                      ),
                TextButton.icon(
                  onPressed: () {
                    context.pop();
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _createUser(UserCredential createUser) {
    context
        .read<UserProvider>()
        .createUser(createUser.user!.uid, createUser.user!.email!);

    _sendVerification();
  }

  void _sendVerification() async {
    await _auth.currentUser?.sendEmailVerification();
    if (mounted) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            content: Text('Email verification sent.'),
          ),
        );

      context.pop();
    }
  }
}
