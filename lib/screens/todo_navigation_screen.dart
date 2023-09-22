import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/components/nav_screen/nav_tab_contol.dart';
import 'package:todo_todo/provider/navigation_tab_provider.dart';



class TodoNavigationScreen extends StatelessWidget {
  const TodoNavigationScreen({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Selector<NavigationTabProvider, int>(
      selector: (context, navigationTabProvider) => navigationTabProvider.index,
      builder: (BuildContext context, int index, Widget? child) {
        return NavTabControl(index: index);
      },
    );
  }
}
