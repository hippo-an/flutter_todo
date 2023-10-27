import 'package:flutter/material.dart';
import 'package:todo_todo/archive/core/models/sub_task_form_model.dart';
import 'package:todo_todo/archive/ui/shared/sub_task_form.dart';

class SubTaskFormList extends StatelessWidget {
  const SubTaskFormList({
    super.key,
    required this.subtaskForms,
    required this.onRemove,
  });

  final List<SubTaskFormModel> subtaskForms;
  final void Function(int) onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: subtaskForms.indexed.map(
        (e) {
          final subtaskFormModel = e.$2;
          return SubTaskForm(
            key: ValueKey<String>(subtaskFormModel.subtaskId),
            index: e.$1,
            subtaskFormModel: subtaskFormModel,
            onRemove: onRemove,
          );
        },
      ).toList(),
    );
  }
}
