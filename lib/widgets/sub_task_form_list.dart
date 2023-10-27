import 'package:flutter/material.dart';
import 'package:todo_todo/models/subtask_form_model.dart';
import 'package:todo_todo/widgets/sub_task_form.dart';

class SubTaskFormList extends StatelessWidget {
  const SubTaskFormList({
    super.key,
    required this.subtaskForms,
    required this.onRemove,
  });

  final List<SubtaskFormModel> subtaskForms;
  final void Function(int) onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: subtaskForms.indexed.map(
        (e) {
          final index = e.$1;
          final subtaskFormModel = e.$2;

          return SubTaskForm(
            key: ValueKey<String>(subtaskFormModel.subtaskId),
            index: index,
            subtaskFormModel: subtaskFormModel,
            onRemove: onRemove,
          );
        },
      ).toList(),
    );
  }
}
