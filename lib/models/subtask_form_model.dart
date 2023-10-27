
class SubtaskFormModel {
  final String subtaskId;
  String? name;
  bool isDone;

  SubtaskFormModel({
    required this.subtaskId,
    this.name,
    this.isDone = false,
  });
}
