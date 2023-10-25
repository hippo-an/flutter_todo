import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/colors.dart';
import 'package:todo_todo/controller/auth_controller.dart';
import 'package:todo_todo/controller/category_controller.dart';
import 'package:todo_todo/controller/task_controller.dart';
import 'package:todo_todo/firebase_options.dart';
import 'package:todo_todo/locator.dart';
import 'package:todo_todo/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const FlutterTodoApp());
}

class FlutterTodoApp extends StatelessWidget {
  const FlutterTodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => locator<AuthController>(),
        ),
        ChangeNotifierProvider(
          create: (context) => locator<CategoryController>(),
        ),
        ChangeNotifierProvider(
          create: (context) => locator<TaskController>(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        title: 'Flutter-Todo',
        theme: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.fromSeed(seedColor: kColorScheme).copyWith(
            background: kBackgroundColor,
            secondary: kSecondaryColor,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: kBackgroundColor,
            elevation: 0,
          ),
          datePickerTheme: DatePickerThemeData(
            backgroundColor: kWhiteColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(
                  color: kWhiteColor,
                ),
              ),
              textStyle: const TextStyle(
                color: kWhiteColor,
              ),
            ),
          ),
        ),
        themeMode: ThemeMode.system,
      ),
    );
  }
}
