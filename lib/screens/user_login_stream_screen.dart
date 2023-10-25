import 'package:flutter/material.dart';
import 'package:todo_todo/controller/category_controller.dart';
import 'package:todo_todo/locator.dart';
import 'package:todo_todo/repository/auth_repository.dart';
import 'package:todo_todo/screens/home_screen.dart';
import 'package:todo_todo/screens/login_screen.dart';

class UserLoginStreamScreen extends StatefulWidget {

  static const routeName = '/';
  const UserLoginStreamScreen({super.key});

  @override
  State<UserLoginStreamScreen> createState() => _UserLoginStreamScreenState();
}

class _UserLoginStreamScreenState extends State<UserLoginStreamScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) async => await _fetchCategory(),
    );
    super.initState();
  }
  Future<void> _fetchCategory() async {
    print('fetch category @@@@@@@@@@@@@@@@@@@@@@@@@@');
    await locator<CategoryController>().fetchCategoriesForInit();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: locator<AuthRepository>().userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasData) {
          return const HomeScreen();
        }

        if (snapshot.hasError) {
          const Scaffold(
            body: Center(
              child: Text(
                'Something went wrong...',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }

        return const LoginScreen();
      },
    );
  }
}
