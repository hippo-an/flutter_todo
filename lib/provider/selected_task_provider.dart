import 'package:flutter/material.dart';
import 'package:todo_todo/models/task_model.dart';

class SelectedTaskProvider extends ChangeNotifier{
  TaskModel? selectedTask;

  void updateSelectedTask(TaskModel selectedTask) {
    this.selectedTask = selectedTask;
  }

}