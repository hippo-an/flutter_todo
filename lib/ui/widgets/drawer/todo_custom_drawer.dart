import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_todo/core/services/auth_service.dart';
import 'package:todo_todo/locator.dart';
import 'package:todo_todo/ui/view/deleted_tasks_screen.dart';
import 'package:todo_todo/ui/view/stared_tasks_screen.dart';
import 'package:todo_todo/ui/widgets/drawer/drawer_category_tile.dart';
import 'package:todo_todo/ui/widgets/drawer/drawer_menu.dart';


class TodoCustomDrawer extends StatelessWidget {
  const TodoCustomDrawer({super.key});

  static const routeName = 'drawer';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const BeveledRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: ListView(
        children: [
          const DrawerHeader(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Todo-Todo',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          DrawerMenu(
            onTab: () {
              context.pushNamed(StaredTaskScreen.routeName);
            },
            iconData: Icons.star,
            menuName: 'Stared tasks',
          ),
          const DrawerCategoryTile(),
          DrawerMenu(
              onTab: () {
                context.pushNamed(DeletedTaskScreen.routeName);
              },
              iconData: Icons.delete_outline,
              menuName: 'Manage Delete'),
          DrawerMenu(
            onTab: () {},
            iconData: Icons.settings,
            menuName: 'Settings',
          ),
          DrawerMenu(
              onTab: () async {
                final googleSignIn = GoogleSignIn();
                if (await googleSignIn.isSignedIn()) {
                  await googleSignIn.disconnect();
                }
                
                await locator<AuthService>().signOut();
              },
              iconData: Icons.delete_outline,
              menuName: 'Logout'),
        ],
      ),
    );
  }
}
