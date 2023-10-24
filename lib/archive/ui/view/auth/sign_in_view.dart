import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_todo/archive/locator.dart';
import 'package:todo_todo/archive/core/services/auth_service.dart';
import 'package:todo_todo/archive/ui/view/auth/sign_up_view.dart';
import 'package:todo_todo/widgets/text_field_input.dart';
import 'package:todo_todo/widgets/todo_logo.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _isGoogleLoading = false;
  bool _isEmailLoading = false;
  bool _isFacebookLoading = false;
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

  Future<void> _signWithGoogle() async {
    setState(() {
      _isGoogleLoading = true;
    });

    final (:success, :message) =
    await locator<AuthService>().signInWithGoogle();

    setState(() {
      _isGoogleLoading = false;
    });

    if (!success || message != null) {
      _showSignInSnackBar(message: message);
    }
  }

  Future<void> _loginWithEmail() async {
    setState(() {
      _isEmailLoading = true;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty) {
      setState(() {
        _showSignInSnackBar(message: 'Fill the Email');
        _isEmailLoading = false;
      });
      return;
    }

    if (email.length < 4 || !email.contains('@')) {
      setState(() {
        _showSignInSnackBar(message: 'Invalid Email');
        _isEmailLoading = false;
      });
      return;
    }

    if (password.isEmpty) {
      setState(() {
        _showSignInSnackBar(message: 'Fill the Password');
        _isEmailLoading = false;
      });
      return;
    }

    final (:success, :message) = await locator<AuthService>()
        .signInWithEmailAndPassword(email: email, password: password);

    setState(() {
      _isEmailLoading = false;
    });

    if (!success) {
      _passwordController.clear();
      _showSignInSnackBar(message: message);
    }
  }

  void _showSignInSnackBar({String? message}) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message ?? 'Sign in processing...'),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery
        .of(context)
        .viewInsets
        .bottom;
    final width = MediaQuery
        .of(context)
        .size
        .width;
    final signInNotPossible =
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
                        )
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _isEmailLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                  width: width,
                  child: OutlinedButton.icon(
                    onPressed: signInNotPossible
                        ? _showSignInSnackBar
                        : _loginWithEmail,
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
                        context.pushNamed(SignUpView.routeName);
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
                      onPressed: signInNotPossible
                          ? _showSignInSnackBar
                          : _signWithGoogle,
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
                      onPressed:
                      signInNotPossible ? _showSignInSnackBar : () {},
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
}
