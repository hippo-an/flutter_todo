import 'package:todo_todo/models/subtask_form_model.dart';

class SubtaskModel {
  final String subtaskId;
  final String name;
  final bool isDone;

  SubtaskModel({
    required this.subtaskId,
    required this.name,
    this.isDone = false,
  });

  static SubtaskModel fromSubTaskFormModel(SubtaskFormModel subtaskFormModel) {
    return SubtaskModel(
      subtaskId: subtaskFormModel.subtaskId,
      name: subtaskFormModel.name!,
      isDone: subtaskFormModel.isDone,
    );
  }

  static SubtaskModel fromJson(Map<String, dynamic> json) {
    return SubtaskModel(
      subtaskId: json['subtaskId'],
      name: json['name'],
      isDone: json['isDone']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subtaskId': subtaskId,
      'name': name,
      'isDone': isDone,
    };
  }

  SubtaskFormModel toSubTaskFormModel() {
    return SubtaskFormModel(
      subtaskId: subtaskId,
      name: name,
      isDone: isDone,
    );
  }

  SubtaskModel copyWith({
    String? name,
    bool? isDone,
  }) {
    return SubtaskModel(
      subtaskId: subtaskId,
      name: name ?? this.name,
      isDone: isDone ?? this.isDone,
    );
  }
}
