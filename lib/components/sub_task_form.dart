import 'package:flutter/material.dart';
import 'package:todo_todo/models/sub_task_form_model.dart';

class SubTaskForm extends StatefulWidget {
  const SubTaskForm({
    super.key,
    required this.index,
    required this.subTaskFormModel,
    required this.onRemove,
  });

  final int index;
  final SubTaskFormModel subTaskFormModel;
  final void Function(int) onRemove;

  @override
  State<SubTaskForm> createState() => _SubTaskFormState();
}

class _SubTaskFormState extends State<SubTaskForm> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey<String>(widget.subTaskFormModel.taskId),
      height: MediaQuery.of(context).size.height * 0.05,
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Transform.scale(
            scale: 0.9,
            child: Checkbox(
              value: _isChecked,
              onChanged: (bool? value) {
                setState(() {
                  _isChecked = value ?? false;
                });
              },
              tristate: true,
              shape: const CircleBorder(),
            ),
          ),
          Expanded(
            child: TextFormField(
              maxLength: 30,
              maxLines: 1,
              decoration: const InputDecoration(
                hintText: 'New subtask max 30 length',
                hintStyle: TextStyle(
                  fontSize: 14,
                ),
                counter: SizedBox.shrink(),
              ),
              style: const TextStyle(),
              onChanged: (String? value) {
                if (value != null && value.isNotEmpty) {
                  widget.subTaskFormModel.name = value;
                }
              },
              validator: (String? value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Fill the blank';
                }

                return null;
              },
            ),
          ),
          IconButton(
            onPressed: () {
              widget.onRemove(widget.index);
            },
            icon: const Icon(
              Icons.close_sharp,
              size: 12,
            ),
          )
        ],
      ),
    );
  }
}
