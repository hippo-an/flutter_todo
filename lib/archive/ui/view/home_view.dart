import 'package:flutter/material.dart';
import 'package:todo_todo/archive/core/services/auth_service.dart';
import 'package:todo_todo/archive/locator.dart';
import 'package:todo_todo/archive/ui/view/auth/sign_in_view.dart';
import 'package:todo_todo/archive/ui/view/navigation_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: locator<AuthService>().streamUser,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasData == true) {
          return const NavigationView();
        }

        return const SignInView();
      },
    );
  }
}
