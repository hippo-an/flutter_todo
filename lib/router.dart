import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_todo/screens/manage_category_screen.dart';
import 'package:todo_todo/screens/task_detail_screen.dart';
import 'package:todo_todo/screens/task_list_screen.dart';
import 'package:todo_todo/screens/todo_calendar_screen.dart';
import 'package:todo_todo/screens/todo_navigation_screen.dart';

final router = GoRouter(
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
            GoRoute(
              path: TaskDetailScreen.routeName,
              builder: (context, state) => const TaskDetailScreen(),
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