import 'package:todo_todo/consts/tools.dart';



class SubTaskFormModel {
  final String _subTaskId;
  String? name;
  final bool isDone;

  SubTaskFormModel({
    this.isDone = false,
  }): _subTaskId = uuid.generate();

  get taskId => _subTaskId;
}
