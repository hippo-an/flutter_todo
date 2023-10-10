import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/core/view_models/category_view_model.dart';
import 'package:todo_todo/core/view_models/navigation_tab_provider.dart';
import 'package:todo_todo/locator.dart';
import 'package:todo_todo/ui/view/task_calendar_screen.dart';
import 'package:todo_todo/ui/view/task_list_screen.dart';
import 'package:todo_todo/ui/widgets/drawer/todo_custom_drawer.dart';
import 'package:todo_todo/ui/widgets/manage_category_screen/category_list.dart';
import 'package:todo_todo/ui/widgets/nav_screen/todo_custom_tab_bar.dart';

final Map<Widget, IconData> _tabBarWidgets = {
  const TaskListScreen(): Icons.task_alt,
  const TodoCalendarScreen(): Icons.calendar_month,
  const Scaffold(): Icons.person,
};

class NavTabControl extends StatefulWidget {
  const NavTabControl({super.key, required this.index});

  final int index;

  @override
  State<NavTabControl> createState() => _NavTabControlState();
}

class _NavTabControlState extends State<NavTabControl> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabBarWidgets.length,
      initialIndex: widget.index,
      child: SafeArea(
        child: Scaffold(
          drawer: const TodoCustomDrawer(),
          bottomNavigationBar: TodoCustomTabBar(
            tabBarConfig: _tabBarWidgets,
            selectedIndex: widget.index,
            onTap: (selectedIndex) {
              if (widget.index == selectedIndex) {
                return;
              }
              context.read<NavigationTabProvider>().selectIndex(selectedIndex);
            },
          ),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: IndexedStack(
                sizing: StackFit.expand,
                index: widget.index,
                children: _tabBarWidgets.keys.toList()
            ),
          ),
        ),
      ),
    );
  }
}
