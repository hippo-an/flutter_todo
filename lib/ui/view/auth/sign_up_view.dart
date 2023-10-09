import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_todo/core/services/auth_service.dart';
import 'package:todo_todo/locator.dart';

import '../../widgets/auth/todo_logo.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  static String routeName = 'sign_up';

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
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

  void _showSignUpSnackBar({String? message}) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message ?? 'Sign up processing...'),
        ),
      );
  }

  Future<void> _signUpWithEmail() async {
    setState(() {
      _isEmailLoading = true;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty) {
      setState(() {
        _showSignUpSnackBar(message: 'Fill the Email.');
        _isEmailLoading = false;
      });
      return;
    }

    if (email.length < 4 || !email.contains('@')) {
      setState(() {
        _showSignUpSnackBar(message: 'Invalid Email');
        _isEmailLoading = false;
      });
      return;
    }

    if (password.isEmpty) {
      setState(() {
        _showSignUpSnackBar(message: 'Fill the Password');
        _isEmailLoading = false;
      });
      return;
    }

    if (password.length < 8) {
      setState(() {
        _showSignUpSnackBar(message: 'Password is too short');
        _isEmailLoading = false;
      });
      return;
    }

    final (:success, :message) = await locator<AuthService>()
        .signUpWithEmailAndPassword(email: email, password: password);

    setState(() {
      _isEmailLoading = false;
    });

    if (!success) {
      _passwordController.clear();
      _showSignUpSnackBar(message: message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    final width = MediaQuery.of(context).size.width;
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
                const TodoLogo(),
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
}
