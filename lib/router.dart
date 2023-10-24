import 'package:go_router/go_router.dart';
import 'package:todo_todo/screens/home_screen.dart';
import 'package:todo_todo/screens/login_screen.dart';
import 'package:todo_todo/screens/sign_up_screen.dart';

final router = GoRouter(
  initialLocation: LoginScreen.routeName,
  routes: [
    GoRoute(
      path: LoginScreen.routeName,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: SignUpScreen.routeName,
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: HomeScreen.routeName,
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
