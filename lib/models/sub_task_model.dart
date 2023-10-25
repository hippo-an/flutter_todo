import 'package:todo_todo/models/sub_task_form_model.dart';

class SubTaskModel {
  final String subTaskId;
  final String name;
  final bool isDone;

  SubTaskModel({
    required this.subTaskId,
    required this.name,
    this.isDone = false,
  });

  static SubTaskModel fromSubTaskFormModel(SubTaskFormModel subTaskFormModel) {
    return SubTaskModel(
      subTaskId: subTaskFormModel.subTaskId,
      name: subTaskFormModel.name!,
      isDone: subTaskFormModel.isDone,
    );
  }

  static SubTaskModel fromJson(Map<String, dynamic> json) {
    return SubTaskModel(
      subTaskId: json['subTaskId'],
      name: json['name'],
      isDone: bool.tryParse(json['isDone']) ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subTaskId': subTaskId,
      'name': name,
      'isDone': isDone,
    };
  }

  SubTaskFormModel toSubTaskFormModel() {
    return SubTaskFormModel(
      subTaskId: subTaskId,
      name: name,
      isDone: isDone,
    );
  }

  SubTaskModel copyWith({
    String? name,
    bool? isDone,
  }) {
    return SubTaskModel(
      subTaskId: subTaskId,
      name: name ?? this.name,
      isDone: isDone ?? this.isDone,
    );
  }
}
