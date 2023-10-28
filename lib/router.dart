import 'package:go_router/go_router.dart';
import 'package:todo_todo/models/task_model.dart';
import 'package:todo_todo/screens/category_list_screen.dart';
import 'package:todo_todo/screens/deleted_task_screen.dart';
import 'package:todo_todo/screens/login_screen.dart';
import 'package:todo_todo/screens/sign_up_screen.dart';
import 'package:todo_todo/screens/task_detail_screen.dart';
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
    GoRoute(
      path: TaskDetailScreen.routeName,
      builder: (context, state) => TaskDetailScreen(
        task: state.extra as TaskModel,
      ),
    ),
    GoRoute(
      path: DeletedTaskScreen.routeName,
      builder: (context, state) => const DeletedTaskScreen(),
    ),
  ],
);
