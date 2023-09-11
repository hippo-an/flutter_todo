import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/provider/selected_category_provider.dart';

class AddCategoryAlertDialog extends StatefulWidget {
  const AddCategoryAlertDialog({
    super.key,
    this.isEditMode = false,
  });

  final bool isEditMode;

  @override
  State<AddCategoryAlertDialog> createState() => _AddCategoryAlertDialogState();
}

class _AddCategoryAlertDialogState extends State<AddCategoryAlertDialog> {
  late TextEditingController _categoryController;

  @override
  void initState() {
    super.initState();
    _categoryController = TextEditingController();
  }

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  void _onSavePressed() {
    final name = _categoryController.text.trim();
    if (name.isEmpty) {
      _categoryController.clear();
      return;
    }

    Provider.of<CategoryProvider>(context, listen: false).createCategory(name);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isEditMode ? 'Edit category' : 'Create new category'),
      titleTextStyle: const TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            autofocus: true,
            controller: _categoryController,
            maxLines: 1,
            maxLength: 30,
            expands: false,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              floatingLabelAlignment: FloatingLabelAlignment.start,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  color: Colors.lightBlueAccent,
                ),
              ),
              labelText: 'Add Category',
              labelStyle: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _onSavePressed,
          child: const Text("Save"),
        )
      ],
    );
  }
}
