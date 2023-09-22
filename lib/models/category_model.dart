import 'package:flutter/material.dart';
import 'package:todo_todo/consts/enums.dart';

class CategoryModel {
  CategoryModel({
    required this.categoryId,
    required this.name,
    required this.colorCode,
    required this.createdAt,
    required this.updatedAt,
    this.categoryState = CategoryState.activated,
    this.isDeleted = false,
  });

  final String categoryId;
  final String name;
  final int colorCode;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CategoryState categoryState;
  final bool isDeleted;

  get color => Color(colorCode);

  static CategoryModel fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryId: json['categoryId'],
      name: json['name'],
      colorCode: int.tryParse(json['colorCode']) ?? 0xFFFFFFFF,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'name': name,
      'colorCode': colorCode.toString(),
      'createdAt': createdAt.toString(),
      'updatedAt': updatedAt.toString(),
      'categoryState': categoryState.name,
      'isDeleted': isDeleted.toString(),
    };
  }

  CategoryModel copyWith({
    String? name,
    CategoryState? categoryState,
    int? colorCode,
    bool? isDeleted,
    DateTime? updatedAt,
  }) {
    return CategoryModel(
      categoryId: categoryId,
      name: name ?? this.name,
      categoryState: categoryState ?? this.categoryState,
      colorCode: colorCode ?? this.colorCode,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  int get hashCode => categoryId.hashCode ^ categoryState.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryModel &&
          runtimeType == other.runtimeType &&
          categoryId == other.categoryId &&
          categoryState == other.categoryState;
}
