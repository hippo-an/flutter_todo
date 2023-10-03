import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/firebase_options.dart';
import 'package:todo_todo/provider/category_list_provider.dart';
import 'package:todo_todo/provider/drawer_provider.dart';
import 'package:todo_todo/provider/main_calendar_provider.dart';
import 'package:todo_todo/provider/navigation_tab_provider.dart';
import 'package:todo_todo/provider/task_list_provider.dart';
import 'package:todo_todo/provider/task_list_section_provider.dart';
import 'package:todo_todo/router.dart';
import 'package:todo_todo/theme.dart';

final _router = router;

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const TodoTodoApp());
}

final providers = [
  ChangeNotifierProvider(
    create: (_) => NavigationTabProvider(),
  ),
  ChangeNotifierProvider(
    create: (_) => MainCalendarProvider(),
  ),
  ChangeNotifierProvider(
    create: (_) => DrawerProvider(),
  ),
  ChangeNotifierProvider(
    create: (_) => CategoryListProvider(),
  ),
  ChangeNotifierProxyProvider<CategoryListProvider, TaskListProvider>(
    create: (context) => TaskListProvider(null),
    update: (context, categoryListProvider, taskListProvider) =>
        taskListProvider!
          ..initializeSelectedCategory(
              categoryListProvider.selectedCategory),
  ),
  ChangeNotifierProvider(
    create: (_) => TaskListSectionProvider(),
  ),
];

class TodoTodoApp extends StatelessWidget {
  const TodoTodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp.router(
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
        title: 'Todo-Todo',
        theme:
            ThemeData().copyWith(useMaterial3: true, colorScheme: kColorScheme),
        themeMode: ThemeMode.light,
      ),
    );
  }
}
