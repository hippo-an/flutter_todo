import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_todo/archive/core/services/auth_service.dart';
import 'package:todo_todo/archive/locator.dart';
import 'package:todo_todo/widgets/text_field_input.dart';

import '../../../../widgets/todo_logo.dart';

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

    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
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
                    TextFieldInput(
                      controller: _emailController,
                      label: 'Email',
                      textInputType: TextInputType.emailAddress,
                      isPassword: false,
                    ),
                    const SizedBox(height: 8),
                    TextFieldInput(
                        controller: _passwordController,
                        label: 'Password',
                        textInputType: TextInputType.text,
                        isPassword: _obscure,
                        suffixIcon: IconButton(
                          icon: Icon(_obscure
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _obscure = !_obscure;
                            });
                          },
                        )),
                    const SizedBox(height: 8),
                  ],
                ),
                _isEmailLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: width,
                        child: OutlinedButton.icon(
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
