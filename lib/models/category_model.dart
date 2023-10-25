import 'package:flutter/material.dart';
import 'package:todo_todo/archive/common/enums.dart';

class CategoryModel {
  CategoryModel({
    required this.categoryId,
    required this.userId,
    required this.name,
    required this.colorCode,
    this.taskCount = 0,
    required this.sortNumber,
    required this.createdAt,
    required this.updatedAt,
    this.categoryState = CategoryState.seen,
    this.isDeleted = false,
    this.isDefault = false,
  });

  final String categoryId;
  final String userId;
  final String name;
  final int colorCode;
  final int taskCount;
  final int sortNumber;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CategoryState categoryState;
  final bool isDeleted;
  final bool isDefault;

  get color => Color(colorCode);

  static CategoryModel fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryId: json['categoryId'],
      userId: json['userId'],
      name: json['name'],
      colorCode: json['colorCode'] ?? 0xFFFFFFFF,
      taskCount: json['taskCount'] ?? 0,
      sortNumber: json['sortNumber'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      categoryState: CategoryState.values.byName(json['categoryState']),
      isDeleted: json['isDeleted'] ?? false,
      isDefault: json['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'userId': userId,
      'name': name,
      'colorCode': colorCode,
      'taskCount': taskCount,
      'sortNumber': sortNumber,
      'createdAt': createdAt.toString(),
      'updatedAt': updatedAt.toString(),
      'categoryState': categoryState.name,
      'isDeleted': isDeleted,
      'isDefault': isDefault,
    };
  }

  CategoryModel copyWith({
    String? name,
    int? colorCode,
    int? taskCount,
    int? sortNumber,
    DateTime? updatedAt,
    CategoryState? categoryState,
    bool? isDeleted,
    bool? isDefault,
  }) {
    return CategoryModel(
      categoryId: categoryId,
      userId: userId,
      name: name ?? this.name,
      colorCode: colorCode ?? this.colorCode,
      taskCount: taskCount ?? this.taskCount,
      sortNumber: sortNumber ?? this.sortNumber,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      categoryState: categoryState ?? this.categoryState,
      isDeleted: isDeleted ?? this.isDeleted,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  int get hashCode => categoryId.hashCode ;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryModel &&
          runtimeType == other.runtimeType &&
          categoryId == other.categoryId;
}
