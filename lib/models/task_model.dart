import 'package:todo_todo/models/enums.dart';

class TaskModel {
  final String taskName;
  final String? note;
  final Urgent urgent;
  final Importance importance;
  final Priority priority;
  final Progression progression;
  final bool isDone;

  const TaskModel({
    required this.taskName,
    this.note,
    this.urgent = Urgent.notUrgent,
    this.importance = Importance.notImportance,
    this.priority = Priority.normal,
    this.progression = Progression.ready,
    this.isDone = false,
  });
}
