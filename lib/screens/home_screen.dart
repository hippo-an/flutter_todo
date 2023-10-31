import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/controller/calendar_format_controller.dart';
import 'package:todo_todo/controller/calendar_marker_controller.dart';
import 'package:todo_todo/controller/calendar_selected_date_controller.dart';
import 'package:todo_todo/controller/category_controller.dart';
import 'package:todo_todo/controller/task_calendar_reload_controller.dart';
import 'package:todo_todo/controller/task_tab_open_controller.dart';
import 'package:todo_todo/locator.dart';
import 'package:todo_todo/repository/auth_repository.dart';
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
  @override
  void initState() {
    super.initState();
    _fetchCategory();
  }

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

  Future<void> _fetchCategory() async {
    await Provider.of<CategoryController>(context, listen: false)
        .fetchCategoriesForInit();
    Provider.of<CategoryController>(context, listen: false)
        .selectedCategoryForInit();
    Provider.of<CalendarMarkerController>(context, listen: false).init();
    Provider.of<CalendarFormatController>(context, listen: false).init();
    Provider.of<CalendarSelectedDateController>(context, listen: false).init();
    locator<TaskTabOpenController>().init();
  }

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
                  Provider.of<TaskCalendarReloadController>(context,
                          listen: false)
                      .reload();
                  Provider.of<CalendarMarkerController>(context, listen: false)
                      .fetchMarker(
                    uid: locator<AuthRepository>().currentUser.uid,
                    selectedMonth: context
                        .read<CalendarSelectedDateController>()
                        .selectedDate,
                    categoryIds:
                        Provider.of<CategoryController>(context, listen: false)
                            .seenCategoryIds,
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
