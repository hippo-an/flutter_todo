import 'package:flutter/material.dart';
import 'package:todo_todo/components/todo_custom_drawer.dart';
import 'package:todo_todo/components/todo_custom_tab_bar.dart';
import 'package:todo_todo/screens/task_list_screen.dart';
import 'package:todo_todo/screens/todo_calendar_screen.dart';

class TodoNavigationScreen extends StatefulWidget {
  const TodoNavigationScreen({super.key});

  static const routeName = '/';

  @override
  State<TodoNavigationScreen> createState() => _TodoNavigationScreenState();
}

class _TodoNavigationScreenState extends State<TodoNavigationScreen> {
  final Map<Widget, IconData> _tabBarConfig = {
    const TaskListScreen(): Icons.task_alt,
    const TodoCalendarScreen(): Icons.calendar_month,
    const Scaffold(): Icons.person,
  };

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabBarConfig.length,
      initialIndex: _selectedIndex,
      child: SafeArea(
        child: Scaffold(
          drawer: const TodoCustomDrawer(),
          bottomNavigationBar: TodoCustomTabBar(
            tabBarConfig: _tabBarConfig,
            selectedIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IndexedStack(
              sizing: StackFit.expand,
              index: _selectedIndex,
              children: _tabBarConfig.keys.toList()
            ),
          ),
        ),
      ),
    );
  }
}
