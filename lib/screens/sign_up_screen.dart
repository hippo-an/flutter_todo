import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/controller/auth_controller.dart';
import 'package:todo_todo/screens/login_screen.dart';
import 'package:todo_todo/utils.dart';
import 'package:todo_todo/widgets/text_field_input.dart';
import 'package:todo_todo/widgets/todo_logo.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/sign-up';

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _usernameController;
  bool _isEmailLoading = false;
  bool _obscure = true;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _usernameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _toLoginPage()  {
    context.go(LoginScreen.routeName);
  }

  Future<void> _signUpWithEmail() async {
    setState(() {
      _isEmailLoading = true;
    });

    final success = await Provider.of<AuthController>(context, listen: false)
        .signUpWithEmailAndPassword(
      context: context,
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      username: _usernameController.text.trim(),
    );

    setState(() {
      _isEmailLoading = false;
    });

    if (success) {
      _toLoginPage();
    }
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Theme.of(context).colorScheme.background,
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
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
                    const SizedBox(height: 8),
                    TextFieldInput(
                      controller: _usernameController,
                      label: 'Username',
                      textInputType: TextInputType.text,
                      isPassword: false,
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
                _isEmailLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          onPressed: _signUpWithEmail,
                          child: const Text('Sign Up'),
                        ),
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have account?',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.blueAccent),
                      onPressed: _toLoginPage,
                      child: const Text('Login'),
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
