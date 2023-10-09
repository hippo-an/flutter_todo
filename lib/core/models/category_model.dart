import 'package:flutter/material.dart';
import 'package:todo_todo/common/enums.dart';

class CategoryModel {
  CategoryModel({
    required this.categoryId,
    required this.name,
    required this.colorCode,
    this.taskCount = 0,
    required this.createdAt,
    required this.updatedAt,
    this.categoryState = CategoryState.seen,
    this.isDeleted = false,
    this.isDefault = false,
  });

  final String categoryId;
  final String name;
  final int colorCode;
  final int taskCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CategoryState categoryState;
  final bool isDeleted;
  final bool isDefault;

  get color => Color(colorCode);

  static CategoryModel fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryId: json['categoryId'],
      name: json['name'],
      colorCode: int.tryParse(json['colorCode']) ?? 0xFFFFFFFF,
      taskCount: int.tryParse(json['taskCount']) ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      categoryState: CategoryState.values.byName(json['categoryState']),
      isDeleted: bool.tryParse(json['isDeleted']) ?? false,
      isDefault: bool.tryParse(json['isDefault']) ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'name': name,
      'colorCode': colorCode.toString(),
      'taskCount': taskCount.toString(),
      'createdAt': createdAt.toString(),
      'updatedAt': updatedAt.toString(),
      'categoryState': categoryState.name,
      'isDeleted': isDeleted.toString(),
      'isDefault': isDefault.toString(),
    };
  }

  CategoryModel copyWith({
    String? name,
    int? colorCode,
    int? taskCount,
    int? completeCount,
    DateTime? updatedAt,
    CategoryState? categoryState,
    bool? isDeleted,
    bool? isDefault,
  }) {
    return CategoryModel(
      categoryId: categoryId,
      name: name ?? this.name,
      colorCode: colorCode ?? this.colorCode,
      taskCount: taskCount ?? this.taskCount,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      categoryState: categoryState ?? this.categoryState,
      isDeleted: isDeleted ?? this.isDeleted,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  int get hashCode => categoryId.hashCode ^ categoryState.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryModel &&
          runtimeType == other.runtimeType &&
          categoryId == other.categoryId;
}
