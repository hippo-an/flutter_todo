import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({
    super.key,
    required this.onTab,
    required this.iconData,
    required this.title,
  });

  final void Function() onTab;
  final IconData iconData;
  final String title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onTap: onTab,
      child: ListTile(
        isThreeLine: false,
        leading: Icon(
          iconData,
          size: 26,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(title),
      ),
    );
  }
}
