import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_todo/common/theme.dart';
import 'package:todo_todo/core/services/repository/category_repository.dart';
import 'package:todo_todo/core/services/repository/task_repository.dart';
import 'package:todo_todo/core/view_models/category_list_provider.dart';
import 'package:todo_todo/core/view_models/drawer_provider.dart';
import 'package:todo_todo/core/view_models/main_calendar_provider.dart';
import 'package:todo_todo/core/view_models/navigation_tab_provider.dart';
import 'package:todo_todo/core/view_models/task_list_provider.dart';
import 'package:todo_todo/core/view_models/task_list_section_provider.dart';
import 'package:todo_todo/firebase_options.dart';
import 'package:todo_todo/locator.dart';
import 'package:todo_todo/router.dart';

final provider = [
  ChangeNotifierProvider(
    create: (_) => NavigationTabProvider(),
  ),
  ChangeNotifierProvider(
    create: (_) => MainCalendarProvider(locator<TaskRepository>()),
  ),
  ChangeNotifierProvider(
    create: (_) => DrawerProvider(),
  ),
  ChangeNotifierProvider(
    create: (_) => CategoryListProvider(locator<CategoryRepository>()),
  ),
  ChangeNotifierProxyProvider<CategoryListProvider, TaskListProvider>(
    create: (context) => TaskListProvider(null, locator<TaskRepository>()),
    update: (context, categoryListProvider, taskListProvider) =>
        taskListProvider!
          ..initializeSelectedCategory(categoryListProvider.selectedCategory),
  ),
  ChangeNotifierProvider(
    create: (_) => TaskListSectionProvider(),
  ),
];



Future<void> _initPrefs() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool? isOnboardingDone = prefs.getBool('isOnboardingDone');

  if (isOnboardingDone == null) {
    prefs.setBool('isOnboardingDone', false);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();

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
        themeMode: ThemeMode.system,
      ),
    );
  }
}
