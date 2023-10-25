import 'package:go_router/go_router.dart';
import 'package:todo_todo/screens/category_list_screen.dart';
import 'package:todo_todo/screens/login_screen.dart';
import 'package:todo_todo/screens/sign_up_screen.dart';
import 'package:todo_todo/screens/user_login_stream_screen.dart';

final router = GoRouter(
  initialLocation: UserLoginStreamScreen.routeName,
  routes: [
    GoRoute(
      path: UserLoginStreamScreen.routeName,
      builder: (context, state) => const UserLoginStreamScreen(),
    ),
    GoRoute(
      path: LoginScreen.routeName,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: SignUpScreen.routeName,
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: CategoryListScreen.routeName,
      builder: (context, state) => const CategoryListScreen(),
    ),
  ],
);
