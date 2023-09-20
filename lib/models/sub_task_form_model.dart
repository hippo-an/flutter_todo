
class SubTaskFormModel {
  final String subTaskId;
  String? name;
  bool isDone;

  SubTaskFormModel({
    required this.subTaskId,
    this.name,
    this.isDone = false,
  });
}
