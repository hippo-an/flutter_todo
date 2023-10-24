import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/archive/locator.dart';
import 'package:todo_todo/archive/core/view_models/category_view_model.dart';
import 'package:todo_todo/archive/core/view_models/navigation_tab_provider.dart';
import 'package:todo_todo/archive/ui/view/task_calendar_screen.dart';
import 'package:todo_todo/archive/ui/view/task_list_screen.dart';
import 'package:todo_todo/archive/ui/widgets/drawer/todo_custom_drawer.dart';
import 'package:todo_todo/archive/ui/widgets/nav_screen/todo_custom_tab_bar.dart';

final Map<Widget, IconData> _tabBarWidgets = {
  const TaskListScreen(): Icons.task_alt,
  const TodoCalendarScreen(): Icons.calendar_month,
  const Scaffold(): Icons.person,
};

class NavigationView extends StatefulWidget {
  const NavigationView({super.key});

  @override
  State<NavigationView> createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) => _initCategoryAndTask(),
    );
  }

  Future<void> _initCategoryAndTask() async {
    await locator<CategoryViewModel>().init();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<NavigationTabProvider, int>(
      selector: (context, navigationTabProvider) => navigationTabProvider.index,
      builder: (BuildContext context, int index, Widget? child) {
        return DefaultTabController(
          length: _tabBarWidgets.length,
          initialIndex: index,
          child: SafeArea(
            child: Scaffold(
              drawer: const TodoCustomDrawer(),
              bottomNavigationBar: TodoCustomTabBar(
                tabBarConfig: _tabBarWidgets,
                selectedIndex: index,
                onTap: (selectedIndex) {
                  if (index == selectedIndex) {
                    return;
                  }
                  context
                      .read<NavigationTabProvider>()
                      .selectIndex(selectedIndex);
                },
              ),
              body: Padding(
                padding: const EdgeInsets.all(10),
                child: IndexedStack(
                    sizing: StackFit.expand,
                    index: index,
                    children: _tabBarWidgets.keys.toList()),
              ),
            ),
          ),
        );
      },
    );
  }
}
