import 'package:flutter/material.dart';

class NavigationTabProvider with ChangeNotifier {
  int _index = 0;

  int get index => _index;

  void selectIndex(int index) {
    _index = index;
    notifyListeners();
  }

}