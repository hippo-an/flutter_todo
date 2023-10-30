class MarkerModel {
  final DateTime dueDate;
  final String categoryId;
  final String taskId;
  MarkerModel({
    required this.dueDate,
    required this.categoryId,
    required this.taskId,
  });

  factory MarkerModel.fromJson(Map<String, dynamic> data) {
    final dueDate = DateTime.tryParse(data['dueDate']) ?? DateTime.now();

    return MarkerModel(
      dueDate: DateTime(dueDate.year, dueDate.month, dueDate.day),
      categoryId: data['categoryId'],
      taskId: data['taskId'],
    );
  }
}
