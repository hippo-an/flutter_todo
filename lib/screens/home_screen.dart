import 'package:flutter/material.dart';
import 'package:todo_todo/screens/profile_screen.dart';
import 'package:todo_todo/screens/task_calendar_screen.dart';
import 'package:todo_todo/screens/task_list_screen.dart';
import 'package:todo_todo/widgets/animated_floating_button.dart';
import 'package:todo_todo/widgets/custom_bottom_navigation_bar.dart';
import 'package:todo_todo/widgets/custom_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 2;

  final List<Widget> _tabs = [
    const TaskListScreen(),
    TaskCalendarScreen(
      key: UniqueKey(),
    ),
    ProfileScreen(
      key: UniqueKey(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: _selectedIndex,
      child: SafeArea(
        child: Scaffold(
          floatingActionButton:
              _selectedIndex != 2 ? const AnimatedFloatingButton() : null,
          drawer: const CustomDrawer(),
          bottomNavigationBar: CustomBottomNavigationBar(
            onTap: (value) {
              if (value != _selectedIndex) {
                if (value == 1) {
                  _tabs.removeAt(value);
                  _tabs.insert(
                    value,
                    TaskCalendarScreen(
                      key: UniqueKey(),
                    ),
                  );
                } else if (value == 2) {
                  _tabs.removeAt(value);
                  _tabs.insert(
                    value,
                    ProfileScreen(
                      key: UniqueKey(),
                    ),
                  );
                }

                setState(() {
                  _selectedIndex = value;
                });
              }
            },
          ),
          body: Container(
            padding: const EdgeInsets.all(16),
            child: IndexedStack(
              index: _selectedIndex,
              children: _tabs,
            ),
          ),
        ),
      ),
    );
  }
}
