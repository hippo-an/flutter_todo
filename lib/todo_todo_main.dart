import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/provider/main_calendar_provider.dart';
import 'package:todo_todo/screens/todo_home_screen.dart';

var kColorScheme = ColorScheme.fromSeed(seedColor: const Color(0xFFF3FDE8));

var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 68, 65, 98),
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
              create: (BuildContext context) => MainCalendarProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'TodoTodo',
          theme:
          ThemeData().copyWith(useMaterial3: true, colorScheme: kColorScheme),
          themeMode: ThemeMode.light,
          home: const SafeArea(
            child: TodoHomeScreen(),
          ),
        ),
    );
  }
}
