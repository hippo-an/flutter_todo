import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/core/services/auth_service.dart';
import 'package:todo_todo/core/view_models/navigation_tab_provider.dart';
import 'package:todo_todo/locator.dart';
import 'package:todo_todo/ui/view/auth/sign_in_view.dart';
import 'package:todo_todo/ui/widgets/nav_screen/nav_tab_contol.dart';

class TodoNavigationScreen extends StatelessWidget {
  const TodoNavigationScreen({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: locator<AuthService>().streamUser,
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

        return const SignInView();
      },
    );
  }
}
