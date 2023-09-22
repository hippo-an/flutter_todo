import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/provider/category_list_provider.dart';
import 'package:todo_todo/provider/drawer_provider.dart';
import 'package:todo_todo/provider/main_calendar_provider.dart';
import 'package:todo_todo/provider/selected_category_provider.dart';
import 'package:todo_todo/provider/selected_task_provider.dart';
import 'package:todo_todo/provider/task_list_provider.dart';
import 'package:todo_todo/router.dart';
import 'package:todo_todo/provider/navigation_tab_provider.dart';
import 'package:todo_todo/theme.dart';

final _router = router;

Future<void> main() async {
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
          create: (_) => NavigationTabProvider(),
        ),
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
        ChangeNotifierProvider(
          create: (_) => SelectedTaskProvider(),
        ),
      ],
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
