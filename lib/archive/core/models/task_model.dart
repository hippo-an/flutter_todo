import 'dart:convert';
import 'dart:io';

import 'package:todo_todo/archive/common/enums.dart';
import 'package:todo_todo/archive/core/models/sub_task_model.dart';

class TaskModel {
  final String taskId;
  final String taskName;
  final String? note;
  final Urgent urgent;
  final Importance importance;
  final Priority priority;
  final Progression progression;
  final bool isDone;
  final bool isDeleted;
  final bool stared;
  final DateTime? completedDate;
  final String categoryId;
  final DateTime? dueDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
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
    this.isDeleted = false,
    this.stared = false,
    this.completedDate,
    required this.categoryId,
    this.dueDate,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
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
      categoryId: mapObject['categoryId'],
      isDone: bool.tryParse(mapObject['isDone']) ?? false,
      isDeleted: bool.tryParse(mapObject['isDeleted']) ?? false,
      stared: bool.tryParse(mapObject['stared']) ?? false,
      dueDate: DateTime.tryParse(mapObject['dueDate']),
      completedDate: DateTime.tryParse(mapObject['completedDate']),
      createdAt: DateTime.parse(mapObject['createdAt']),
      updatedAt: DateTime.parse(mapObject['updatedAt']),
      deletedAt: DateTime.parse(mapObject['deletedAt']),
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
      'categoryId': categoryId,
      'isDone': isDone.toString(),
      'isDeleted': isDeleted.toString(),
      'stared': stared.toString(),
      'completedDate': completedDate.toString(),
      'dueDate': dueDate.toString(),
      'createdAt': createdAt.toString(),
      'updatedAt': updatedAt.toString(),
      'deletedAt': deletedAt.toString(),
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
    bool? isDeleted,
    bool? stared,
    DateTime? Function()? completedDate,
    String? categoryId,
    DateTime? Function()? dueDate,
    DateTime? updatedAt,
    DateTime? Function()? deletedAt,
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
      isDeleted: isDeleted ?? this.isDeleted,
      stared: stared ?? this.stared,
      completedDate: completedDate != null ? completedDate() : this.completedDate,
      categoryId: categoryId ?? this.categoryId,
      dueDate: dueDate != null ? dueDate() : this.dueDate,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt != null ? deletedAt() : this.deletedAt,
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

  @override
  int get hashCode =>
      taskId.hashCode ^ categoryId.hashCode ^ isDone.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskModel &&
          runtimeType == other.runtimeType &&
          taskId == other.taskId;
}
