import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({
    super.key,
    required this.onTab,
    required this.iconData,
    required this.menuName,
  });

  final void Function() onTab;
  final IconData iconData;
  final String menuName;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onTap: onTab,
      splashColor: Colors.grey[800],
      child: ListTile(
        isThreeLine: false,
        leading: Icon(
          iconData,
          size: 26,
        ),
        title: Text(menuName),
      ),
    );
  }
}
