import 'package:go_router/go_router.dart';
import 'package:todo_todo/screens/home_screen.dart';
import 'package:todo_todo/screens/login_screen.dart';
import 'package:todo_todo/screens/sign_up_screen.dart';
import 'package:todo_todo/widgets/user_login_stream.dart';

final router = GoRouter(
  initialLocation: UserLoginStream.routeName,
  routes: [
    GoRoute(
      path: UserLoginStream.routeName,
      builder: (context, state) => const UserLoginStream(),
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
      path: HomeScreen.routeName,
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
