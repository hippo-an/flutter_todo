import 'package:flutter/material.dart';

const menu = ['1번', '2번', '3번'];

class MenuAnchorExample extends StatefulWidget {
  const MenuAnchorExample({super.key});

  @override
  State<MenuAnchorExample> createState() => _MenuAnchorExampleState();
}

class _MenuAnchorExampleState extends State<MenuAnchorExample> {
  String? selectedMenu;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: MenuAnchor(

        builder:
            (BuildContext context, MenuController controller, Widget? child) {
          return IconButton(
            onPressed: () {
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            },
            icon: const Icon(Icons.more_vert),
            tooltip: 'Show menu',
          );
        },
        menuChildren: List<MenuItemButton>.generate(
          menu.length,
              (int index) => MenuItemButton(
            onPressed: () => setState(() => selectedMenu = menu[index]),
            child: Text(menu[index]),
          ),
        ),
      ),
    );
  }
}
