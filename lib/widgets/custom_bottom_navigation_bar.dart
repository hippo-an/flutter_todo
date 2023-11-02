import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    super.key,
    required this.onTap,
  });

  final void Function(int index) onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: IconButton(
              splashRadius: 10,
              splashColor: Colors.transparent,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu),
            ),
          ),
          Expanded(
            flex: 6,
            child: TabBar(
              unselectedLabelColor: Theme.of(context).colorScheme.secondary,
              indicatorColor: Theme.of(context).colorScheme.primary,
              labelColor: Theme.of(context).colorScheme.primary,
              onTap: onTap,
              indicator: const BoxDecoration(),
              tabs: const [
                Tab(
                  icon: Icon(Icons.task_alt),
                ),
                Tab(
                  icon: Icon(Icons.calendar_month),
                ),
                Tab(
                  icon: Icon(Icons.person),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
