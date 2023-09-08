import 'package:flutter/material.dart';

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
      // color: Colors.orangeAccent,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.menu),
            ),
          ),
          Expanded(
            flex: 5,
            child: TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: Colors.blueAccent,
              unselectedLabelColor: Colors.black38,
              onTap: onTap,
              indicator: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.blueAccent,
                    width: 3,
                  ),
                ),
              ),
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
