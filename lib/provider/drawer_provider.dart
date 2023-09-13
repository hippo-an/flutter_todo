import 'package:flutter/material.dart';

class DrawerProvider extends ChangeNotifier {
  bool _drawerCategoryStatus = true;

  bool get drawerCategoryStatus => _drawerCategoryStatus;

  void updateDrawerCategoryOpenStatus() {
    _drawerCategoryStatus = !_drawerCategoryStatus;
  }
}