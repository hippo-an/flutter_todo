import 'package:flutter/material.dart';
import 'package:todo_todo/screens/calendar.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(223, 219, 201, 234),
);

var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 68, 65, 98),
);

void main() {
  runApp(const TodoTodoApp());
}

class TodoTodoApp extends StatelessWidget {
  const TodoTodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo Todo',
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: kColorScheme
      ),
      themeMode: ThemeMode.light,
      home: CalendarScreen(),
    );
  }
}
