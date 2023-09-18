import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/models/category_model.dart';
import 'package:todo_todo/provider/category_list_provider.dart';

final _colors = <Color>[
  Colors.lightBlueAccent,
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.purple,
];

class AddCategoryAlertDialog extends StatefulWidget {
  const AddCategoryAlertDialog({
    super.key,
    this.isEditMode = false,
    this.color = Colors.lightBlueAccent,
    this.name = '',
    this.categoryIndex = 0,
  });

  final bool isEditMode;
  final Color color;
  final String name;
  final int categoryIndex;

  @override
  State<AddCategoryAlertDialog> createState() => _AddCategoryAlertDialogState();
}

class _AddCategoryAlertDialogState extends State<AddCategoryAlertDialog> {
  late TextEditingController _categoryController;
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _categoryController = TextEditingController();

    if (widget.isEditMode) {
      _categoryController.text = widget.name;
    }

    _selectedColor = widget.color;
  }

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  void _onCreate() {
    final name = _categoryController.text.trim();
    if (name.isEmpty) {
      _categoryController.clear();
      return;
    }

    final createdCategory =
        Provider.of<CategoryListProvider>(context, listen: false)
            .createCategory(name);
    Navigator.of(context).pop(createdCategory);
  }

  void _onUpdate() {
    final name = _categoryController.text.trim();
    if (name.isEmpty) {
      _categoryController.clear();
      return;
    }

    if (name == widget.name && _selectedColor == widget.color) {
      return;
    }

    final updatedCategory = Provider.of<CategoryListProvider>(context, listen: false).updateCategory(
      widget.categoryIndex,
      name,
      _selectedColor,
    );
    Navigator.of(context).pop<CategoryModel>(updatedCategory);
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
            autofocus: !widget.isEditMode,
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
          const SizedBox(
            height: 10,
          ),
          if (widget.isEditMode)
            Row(
              children: _colors
                  .map((color) => GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_selectedColor == color) {
                              return;
                            }

                            _selectedColor = color;
                          });
                        },
                        child: SizedBox(
                          height: 27,
                          width: 27,
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: _selectedColor.value == color.value ? 2 : 0),
                                shape: BoxShape.circle,
                              ),
                              child: CircleAvatar(
                                backgroundColor: color,
                              ),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
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
          onPressed: widget.isEditMode ? _onUpdate : _onCreate,
          child: const Text("Save"),
        )
      ],
    );
  }
}
