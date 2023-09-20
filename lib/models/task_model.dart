import 'dart:convert';
import 'dart:io';

import 'package:todo_todo/consts/enums.dart';
import 'package:todo_todo/models/category_model.dart';
import 'package:todo_todo/models/sub_task_model.dart';

class TaskModel {
  final String taskId;
  final String taskName;
  final String? note;
  final Urgent urgent;
  final Importance importance;
  final Priority priority;
  final Progression progression;
  final bool isDone;
  final CategoryModel? categoryModel;
  final DateTime? dueDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<SubTaskModel> subTasks;
  final File? attachment;

  TaskModel({
    required this.taskId,
    required this.taskName,
    this.note,
    this.urgent = Urgent.notUrgent,
    this.importance = Importance.notImportance,
    this.priority = Priority.normal,
    this.progression = Progression.ready,
    this.isDone = false,
    this.categoryModel,
    this.dueDate,
    required this.createdAt,
    required this.updatedAt,
    this.subTasks = const <SubTaskModel>[],
    this.attachment,
  });

  static TaskModel fromJson(Map<String, dynamic> map) {
    return TaskModel(
      taskId: map['taskId'],
      taskName: map['taskName'],
      note: map['note'],
      urgent: Urgent.values.byName(map['urgent']),
      importance: Importance.values.byName(map['importance']),
      priority: Priority.values.byName(map['priority']),
      progression: Progression.values.byName(map['progression']),
      categoryModel: CategoryModel.fromJson(map['categoryModel']),
      dueDate: DateTime.tryParse(map['dueDate']),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      subTasks: List<SubTaskModel>.from(
        json.decode(map['subTasks']).map(
              (model) => SubTaskModel.fromJson(model),
            ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskId': taskId,
      'taskName': taskName,
      'note': note,
      'urgent': urgent.name,
      'importance': importance.name,
      'priority': priority.name,
      'progression': progression.name,
      'categoryModel': categoryModel?.toJson(),
      'dueDate': dueDate.toString(),
      'createdAt': createdAt.toString(),
      'updatedAt': updatedAt.toString(),
      'subTasks': jsonEncode(subTasks),
    };
  }

  TaskModel copyWith({
    String? taskName,
    String? note,
    Urgent? urgent,
    Importance? importance,
    Priority? priority,
    Progression? progression,
    bool? isDone,
    CategoryModel? categoryModel,
    DateTime? dueDate,
    DateTime? updatedAt,
    List<SubTaskModel>? subTasks,
    File? attachment,
  }) {
    return TaskModel(
      taskId: taskId,
      taskName: taskName ?? this.taskName,
      note: note ?? this.note,
      urgent: urgent ?? this.urgent,
      importance: importance ?? this.importance,
      priority: priority ?? this.priority,
      progression: progression ?? this.progression,
      categoryModel: categoryModel ?? this.categoryModel,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      subTasks: subTasks ?? [...this.subTasks],
      attachment: attachment ?? this.attachment,
    );
  }

  bool isBefore() {
    final now = DateTime.now();
    return dueDate!.year < now.year ||
        (dueDate!.year == now.year && dueDate!.month < now.month) ||
        (dueDate!.year == now.year &&
            dueDate!.month == now.month &&
            dueDate!.day < now.day);
  }
}
