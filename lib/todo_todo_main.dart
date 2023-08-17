import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:todo_todo/screens/home_screen.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFFF3FDE8)
);

var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 68, 65, 98),
);

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  // table calendar 다국어 설정 initialize
  await initializeDateFormatting();

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
      home: HomeScreen(),
    );
  }
}
