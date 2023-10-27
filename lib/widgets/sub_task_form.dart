import 'package:flutter/material.dart';
import 'package:todo_todo/colors.dart';
import 'package:todo_todo/models/subtask_form_model.dart';

class SubTaskForm extends StatefulWidget {
  const SubTaskForm({
    super.key,
    required this.index,
    required this.subtaskFormModel,
    required this.onRemove,
  });

  final int index;
  final SubtaskFormModel subtaskFormModel;
  final void Function(int) onRemove;

  @override
  State<SubTaskForm> createState() => _SubTaskFormState();
}

class _SubTaskFormState extends State<SubTaskForm> {
  late final TextEditingController _textEditingController;
  late bool _isChecked;

  @override
  void initState() {
    _textEditingController =
        TextEditingController(text: widget.subtaskFormModel.name);
    _isChecked = widget.subtaskFormModel.isDone;
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      key: ValueKey<String>(widget.subtaskFormModel.subtaskId),
      height: MediaQuery.of(context).size.height * 0.05,
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Transform.scale(
            scale: 0.9,
            child: Checkbox(
              value: _isChecked,
              onChanged: (bool? value) {
                if (_textEditingController.text.isNotEmpty) {
                  setState(() {
                    _isChecked = value ?? false;
                    widget.subtaskFormModel.isDone = _isChecked;
                  });
                }
              },
              tristate: true,
              shape: const CircleBorder(),
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: _textEditingController,
              maxLength: 30,
              maxLines: 1,
              decoration: const InputDecoration(
                hintText: 'Input new subtask',
                hintStyle: TextStyle(
                  fontSize: 14,
                ),
                counter: SizedBox.shrink(),
              ),
              style: TextStyle(
                decoration: _isChecked && _textEditingController.text.isNotEmpty
                    ? TextDecoration.lineThrough
                    : null,
                color: _isChecked && _textEditingController.text.isNotEmpty
                    ? kGreyColor
                    : kWhiteColor,
                fontSize: 14,
              ),
              onChanged: (String? value) {
                if (value != null && value.isNotEmpty) {
                  widget.subtaskFormModel.name = value;
                } else {
                  setState(() {
                    _isChecked = false;
                  });
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
          ),
        ],
      ),
    );
  }
}
