import 'package:flutter/material.dart';

class CategoryModel {
  CategoryModel({
    required this.id,
    required this.name,
    this.categoryState = CategoryState.activate,
    required this.color,
  }) {
    final now = DateTime.now();
    createdAt = now;
    updatedAt = now;
  }

  final String id;
  String name;
  CategoryState categoryState;
  Color color;
  late final DateTime createdAt;
  late DateTime updatedAt;
}

enum CategoryState { activate, inactivate, deleted }
