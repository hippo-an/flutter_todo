import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_todo/core/models/task_model.dart';
import 'package:todo_todo/ui/view/auth/sign_up_view.dart';
import 'package:todo_todo/ui/view/deleted_tasks_screen.dart';
import 'package:todo_todo/ui/view/manage_category_screen.dart';
import 'package:todo_todo/ui/view/stared_tasks_screen.dart';
import 'package:todo_todo/ui/view/task_calendar_screen.dart';
import 'package:todo_todo/ui/view/task_detail_screen.dart';
import 'package:todo_todo/ui/view/task_list_screen.dart';
import 'package:todo_todo/ui/view/todo_navigation_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: TodoNavigationScreen.routeName,
      builder: (context, state) => const TodoNavigationScreen(),
      name: TodoNavigationScreen.routeName,
      routes: <RouteBase>[
        GoRoute(
          name: TaskListScreen.routeName,
          path: TaskListScreen.routeName,
          builder: (context, state) => const TaskListScreen(),
          routes: [
            GoRoute(
              path: ManageCategoryScreen.routeName,
              name: ManageCategoryScreen.routeName,
              builder: (context, state) => const ManageCategoryScreen(),
            ),
            GoRoute(
              path: TaskDetailScreen.routeName,
              name: TaskDetailScreen.routeName,
              builder: (context, state) =>
                  TaskDetailScreen(task: state.extra as TaskModel),
            ),
          ],
        ),
        GoRoute(
          path: TodoCalendarScreen.routeName,
          name: TodoCalendarScreen.routeName,
          builder: (BuildContext context, GoRouterState state) {
            return const TodoCalendarScreen();
          },
        ),
        GoRoute(
          path: StaredTaskScreen.routeName,
          name: StaredTaskScreen.routeName,
          builder: (BuildContext context, GoRouterState state) {
            return const StaredTaskScreen();
          },
        ),
        GoRoute(
          path: DeletedTaskScreen.routeName,
          name: DeletedTaskScreen.routeName,
          builder: (BuildContext context, GoRouterState state) {
            return const DeletedTaskScreen();
          },
        ),
        GoRoute(
          path: SignUpView.routeName,
          name: SignUpView.routeName,
          builder: (BuildContext context, GoRouterState state) {
            return const SignUpView();
          },
        ),
      ],
    ),
  ],
);
