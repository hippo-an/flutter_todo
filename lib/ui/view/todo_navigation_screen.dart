import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/core/view_models/navigation_tab_provider.dart';
import 'package:todo_todo/ui/view/auth/auth_screen.dart';
import 'package:todo_todo/ui/widgets/nav_screen/nav_tab_contol.dart';

class TodoNavigationScreen extends StatelessWidget {
  const TodoNavigationScreen({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasData == true) {
          return Selector<NavigationTabProvider, int>(
            selector: (context, navigationTabProvider) =>
            navigationTabProvider.index,
            builder: (BuildContext context, int index, Widget? child) {
              return NavTabControl(index: index);
            },
          );
        }

        return const AuthScreen();
      },
    );
  }
}
