import 'package:flutter/material.dart';

class DrawerCategoryProvider extends ChangeNotifier {
  bool _drawerCategoryStatus = true;

  bool get drawerCategoryStatus => _drawerCategoryStatus;

  void updateDrawerCategoryStatus() {
    _drawerCategoryStatus = !_drawerCategoryStatus;
  }
}