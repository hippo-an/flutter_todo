import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/provider/category_list_provider.dart';
import 'package:todo_todo/provider/drawer_provider.dart';
import 'package:todo_todo/provider/main_calendar_provider.dart';
import 'package:todo_todo/provider/selected_category_provider.dart';
import 'package:todo_todo/provider/task_list_provider.dart';
import 'package:todo_todo/screens/manage_category_screen.dart';
import 'package:todo_todo/screens/task_list_screen.dart';
import 'package:todo_todo/screens/todo_calendar_screen.dart';
import 'package:todo_todo/screens/todo_navigation_screen.dart';

var kColorScheme = ColorScheme.fromSeed(seedColor: const Color(0xFFF3FDE8));

var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 68, 65, 98),
);

final _router = GoRouter(
  routes: [
    GoRoute(
      path: TodoNavigationScreen.routeName,
      builder: (context, state) => const TodoNavigationScreen(),
      routes: <RouteBase>[
        GoRoute(
          path: TaskListScreen.routeName,
          builder: (context, state) => const TaskListScreen(),
          routes: [
            GoRoute(
              path: ManageCategoryScreen.routeName,
              builder: (context, state) => const ManageCategoryScreen(),
            ),
          ],
        ),
        GoRoute(
          path: TodoCalendarScreen.routeName,
          builder: (BuildContext context, GoRouterState state) {
            return const TodoCalendarScreen();
          },
        ),
      ],
    ),
  ],
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TodoTodoApp());
}

class TodoTodoApp extends StatelessWidget {
  const TodoTodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MainCalendarProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SelectedCategoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DrawerProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CategoryListProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => TaskListProvider(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
        title: 'TodoTodo',
        theme:
            ThemeData().copyWith(useMaterial3: true, colorScheme: kColorScheme),
        themeMode: ThemeMode.light,
      ),
    );
  }
}
