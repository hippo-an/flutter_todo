import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_todo/core/services/category_repository.dart';
import 'package:todo_todo/core/services/task_repository.dart';
import 'package:todo_todo/core/services/user_repository.dart';
import 'package:todo_todo/core/view_models/category_list_provider.dart';
import 'package:todo_todo/core/view_models/drawer_provider.dart';
import 'package:todo_todo/core/view_models/main_calendar_provider.dart';
import 'package:todo_todo/core/view_models/navigation_tab_provider.dart';
import 'package:todo_todo/core/view_models/task_list_provider.dart';
import 'package:todo_todo/core/view_models/task_list_section_provider.dart';
import 'package:todo_todo/core/view_models/user_provider.dart';
import 'package:todo_todo/firebase_options.dart';
import 'package:todo_todo/router.dart';
import 'package:todo_todo/theme.dart';

final provider = [
  ChangeNotifierProvider(
    create: (_) => NavigationTabProvider(),
  ),
  ChangeNotifierProvider(
    create: (_) => MainCalendarProvider(_taskRepository),
  ),
  ChangeNotifierProvider(
    create: (_) => DrawerProvider(),
  ),
  ChangeNotifierProvider(
    create: (_) => CategoryListProvider(_categoryRepository),
  ),
  ChangeNotifierProxyProvider<CategoryListProvider, TaskListProvider>(
    create: (context) => TaskListProvider(null, _taskRepository),
    update: (context, categoryListProvider, taskListProvider) =>
        taskListProvider!
          ..initializeSelectedCategory(categoryListProvider.selectedCategory),
  ),
  ChangeNotifierProvider(
    create: (_) => TaskListSectionProvider(),
  ),
  ListenableProvider(
    create: (context) => UserProvider(_userRepository),
  ),
];

final _taskRepository = TaskRepository();
final _categoryRepository = CategoryRepository();
final _userRepository = UserRepository();

Future<void> _initPrefs() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool? isOnboardingDone = prefs.getBool('isOnboardingDone');

  if (isOnboardingDone == null) {
    prefs.setBool('isOnboardingDone', false);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await _initPrefs();

  runApp(const TodoTodoApp());
}

class TodoTodoApp extends StatelessWidget {
  const TodoTodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: provider,
      child: MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        title: 'Todo-Todo',
        theme: ThemeData().copyWith(
          useMaterial3: true,
          colorScheme: kColorScheme,
        ),
        themeMode: ThemeMode.light,
      ),
    );
  }
}
