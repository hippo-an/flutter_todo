import 'package:flutter/material.dart';

class AddCategoryAlertDialog extends StatefulWidget {
  const AddCategoryAlertDialog({super.key});

  @override
  State<AddCategoryAlertDialog> createState() => _AddCategoryAlertDialogState();
}

class _AddCategoryAlertDialogState extends State<AddCategoryAlertDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Category"),
      content: TextField(
        controller: _controller,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        MaterialButton(
          elevation: 5.0,
          child: const Text("Save"),
          onPressed: () {
            final enteredText = _controller.text;
            if (enteredText.isEmpty) {
              return;
            }
            print(enteredText);
          },
        )
      ],
    );
  }
}
