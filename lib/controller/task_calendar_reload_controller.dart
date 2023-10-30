import 'package:flutter/material.dart';

class TaskCalendarReloadController extends ChangeNotifier {
  void reload() {
    notifyListeners();
  }
}