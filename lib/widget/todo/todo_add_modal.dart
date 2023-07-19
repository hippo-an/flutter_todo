import 'package:flutter/material.dart';
import 'package:todo_todo/widget/todo/todo_item.dart';

class TodoAddModal extends StatefulWidget {
  final void Function(TodoItem) onTodoAdd;

  const TodoAddModal({super.key, required this.onTodoAdd});

  @override
  State<TodoAddModal> createState() => _TodoAddModalState();
}

class _TodoAddModalState extends State<TodoAddModal> {
  final _titleController = TextEditingController();
  final _shortDescriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _shortDescriptionController.dispose();
    super.dispose();
  }

  void _onTodoAdd() {
    widget.onTodoAdd(
      TodoItem(
        title: _titleController.text,
        shortDescription: _shortDescriptionController.text.trim(),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          TextField(
            controller: _shortDescriptionController,
            decoration: const InputDecoration(
              labelText: 'Short Description',
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: _onTodoAdd,
                child: const Text('추가'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
