import 'package:flutter/material.dart';
import 'package:todo_todo/consts/enums.dart';

class CategoryModel {
  CategoryModel({
    required this.id,
    required this.name,
    this.categoryState = CategoryState.activated,
    required this.color,
    this.isDeleted = false,
  }) {
    final now = DateTime.now();
    createdAt = now;
    updatedAt = now;
  }

  final String id;
  String name;
  CategoryState categoryState;
  Color color;
  bool isDeleted;
  late final DateTime createdAt;
  late DateTime updatedAt;
}
