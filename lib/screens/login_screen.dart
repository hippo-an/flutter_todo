import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/controller/auth_controller.dart';
import 'package:todo_todo/screens/home_screen.dart';
import 'package:todo_todo/screens/sign_up_screen.dart';
import 'package:todo_todo/widgets/text_field_input.dart';
import 'package:todo_todo/widgets/todo_logo.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _isEmailLoading = false;
  bool _isGoogleLoading = false;
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

  Future<void> _loginWithEmail() async {
    setState(() {
      _isEmailLoading = true;
    });

    final success = await Provider.of<AuthController>(context, listen: false)
        .loginWithEmail(
      context: context,
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    setState(() {
      _isEmailLoading = false;
    });

    if (success) {
      if (mounted) {
        context.go(HomeScreen.routeName);
      }
    }
  }

  Future<void> _loginWithGoogle() async {
    setState(() {
      _isGoogleLoading = true;
    });

    final success = await Provider.of<AuthController>(context, listen: false)
        .loginWithGoogle(
      context: context,
    );

    setState(() {
      _isGoogleLoading = false;
    });

    if (success) {
      if (mounted) {
        context.go(HomeScreen.routeName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginImpossible = _isGoogleLoading || _isEmailLoading;

    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Theme.of(context).colorScheme.background,
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
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
                        icon: Icon(
                          _obscure ? Icons.visibility : Icons.visibility_off,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscure = !_obscure;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _isEmailLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          onPressed:
                              loginImpossible ? () {} : _loginWithEmail,
                          child: const Text('Login'),
                        ),
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
                        width: MediaQuery.of(context).size.width,
                        child: ClipRRect(
                          clipBehavior: Clip.hardEdge,
                          borderRadius: BorderRadius.circular(12),
                          child: SignInButton(
                            Buttons.Google,
                            text: 'Login with Google',
                            onPressed: loginImpossible ? () {} : _loginWithGoogle,
                          ),
                        ),
                      ),
                const SizedBox(height: 8),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    clipBehavior: Clip.hardEdge,
                    borderRadius: BorderRadius.circular(12),
                    child: SignInButton(
                      Buttons.Facebook,
                      text: 'Login with Facebook',
                      onPressed: loginImpossible ? () {} : () {},
                    ),
                  ),
                ),
                // const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'If you are first time here',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.blueAccent),
                      onPressed: loginImpossible
                          ? null
                          : () {
                              context.go(SignUpScreen.routeName);
                            },
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
