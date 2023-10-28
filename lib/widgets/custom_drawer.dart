import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_todo/locator.dart';
import 'package:todo_todo/repository/auth_repository.dart';
import 'package:todo_todo/screens/deleted_task_screen.dart';
import 'package:todo_todo/widgets/drawer_category_tile.dart';
import 'package:todo_todo/widgets/drawer_menu.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  Future<void> _logout() async {
    final googleSignIn = GoogleSignIn();
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.disconnect();
    }

    await locator<AuthRepository>().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      width: MediaQuery.of(context).size.width * 0.6,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: ListView(
        children: [
          const DrawerHeader(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Flutter Todo',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          DrawerMenu(
            onTab: () {},
            iconData: Icons.star,
            title: 'Stared tasks',
          ),
          const DrawerCategoryTile(),
          DrawerMenu(
              onTab: () {
                context.push(DeletedTaskScreen.routeName);
              },
              iconData: Icons.delete_outline,
              title: 'Deleted tasks'),
          DrawerMenu(
            onTab: () {},
            iconData: Icons.settings,
            title: 'Settings',
          ),
          DrawerMenu(
            onTab: _logout,
            iconData: Icons.delete_outline,
            title: 'Logout',
          ),
        ],
      ),
    );
  }
}
