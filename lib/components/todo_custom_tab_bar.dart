import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_todo/components/todo_custom_drawer.dart';

class TodoCustomTabBar extends StatelessWidget {
  const TodoCustomTabBar({
    super.key,
    required this.tabBarConfig,
    required this.selectedIndex,
    required this.onTap,
  });

  final Map<Widget, IconData> tabBarConfig;
  final int selectedIndex;
  final void Function(int value) onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu),
            ),
          ),
          Expanded(
            flex: 6,
            child: TabBar(
              unselectedLabelColor: Colors.black38,
              onTap: onTap,
              indicator: const BoxDecoration(),
              tabs: tabBarConfig.values.indexed
                  .map(
                    ((int, IconData) e) => Tab(
                      icon: Icon(
                        e.$2,
                        size: 30,
                        color: e.$1 == selectedIndex
                            ? Colors.blueAccent
                            : Colors.black45,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
