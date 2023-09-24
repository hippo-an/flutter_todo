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
  final DateTime? completedDate;
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
    this.completedDate,
    this.categoryModel,
    this.dueDate,
    required this.createdAt,
    required this.updatedAt,
    this.subTasks = const <SubTaskModel>[],
    this.attachment,
  });

  static TaskModel fromJson(Map<String, dynamic> mapObject) {
    return TaskModel(
      taskId: mapObject['taskId'],
      taskName: mapObject['taskName'],
      note: mapObject['note'],
      urgent: Urgent.values.byName(mapObject['urgent']),
      importance: Importance.values.byName(mapObject['importance']),
      priority: Priority.values.byName(mapObject['priority']),
      progression: Progression.values.byName(mapObject['progression']),
      categoryModel: CategoryModel.fromJson(mapObject['categoryModel']),
      isDone: bool.tryParse(mapObject['isDone']) ?? false,
      dueDate: DateTime.tryParse(mapObject['dueDate']),
      completedDate: DateTime.tryParse(mapObject['completedDate']),
      createdAt: DateTime.parse(mapObject['createdAt']),
      updatedAt: DateTime.parse(mapObject['updatedAt']),
      subTasks: List<SubTaskModel>.from(
        json.decode(mapObject['subTasks']).map(
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
      'isDone': isDone.toString(),
      'completedDate': completedDate.toString(),
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
    DateTime? completedDate,
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
      isDone: isDone ?? this.isDone,
      completedDate: completedDate ?? this.completedDate,
      categoryModel: categoryModel ?? this.categoryModel,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      subTasks: subTasks ?? [...this.subTasks],
      attachment: attachment ?? this.attachment,
    );
  }

  bool get isBeforeThanToday {
    if (dueDate == null) {
      return false;
    }

    final now = DateTime.now();
    return dueDate!.year < now.year ||
        (dueDate!.year == now.year && dueDate!.month < now.month) ||
        (dueDate!.year == now.year &&
            dueDate!.month == now.month &&
            dueDate!.day < now.day);
  }

  bool get isToday {
    if (dueDate == null) {
      return false;
    }

    final now = DateTime.now();
    return dueDate!.year == now.year &&
        dueDate!.month == now.month &&
        dueDate!.day == now.day;
  }

  bool get isFutureThanToday {
    if (dueDate == null) {
      return true;
    }

    final now = DateTime.now();
    return dueDate!.year > now.year ||
        (dueDate!.year == now.year && dueDate!.month > now.month) ||
        (dueDate!.year == now.year &&
            dueDate!.month == now.month &&
            dueDate!.day > now.day);
  }

  bool get isDoneToday {
    if (completedDate == null) {
      return false;
    }

    final now = DateTime.now();
    return completedDate!.year == now.year &&
        completedDate!.month == now.month &&
        completedDate!.day == now.day;
  }

  @override
  int get hashCode =>
      taskId.hashCode ^ categoryModel.hashCode ^ isDone.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskModel &&
          runtimeType == other.runtimeType &&
          taskId == other.taskId;
}
