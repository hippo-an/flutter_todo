import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/archive/locator.dart';
import 'package:todo_todo/archive/common/colors.dart';
import 'package:todo_todo/models/category_model.dart';
import 'package:todo_todo/archive/core/view_models/category_view_model.dart';

final _colors = <Color>[
  kCategoryDefaultColor,
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.purple,
];

class CategoryAlertDialog extends StatefulWidget {
  const CategoryAlertDialog({
    super.key,
    this.isEditMode = false,
    this.category,
  });

  final bool isEditMode;
  final CategoryModel? category;

  @override
  State<CategoryAlertDialog> createState() => _CategoryAlertDialogState();
}

class _CategoryAlertDialogState extends State<CategoryAlertDialog> {
  late TextEditingController _categoryController;
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _categoryController = TextEditingController();

    if (widget.isEditMode) {
      _categoryController.text = widget.category!.name;
    }

    _selectedColor = widget.category?.color ?? kCategoryDefaultColor;
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

    final createdCategory = locator<CategoryViewModel>().createCategory(name);
    Navigator.of(context).pop(createdCategory);
  }

  void _onUpdate() {
    final name = _categoryController.text.trim();
    if (name.isEmpty) {
      _categoryController.clear();
      return;
    }

    if (widget.category != null &&
        name == widget.category!.name &&
        _selectedColor == widget.category!.color) {
      return;
    }

    locator<CategoryViewModel>().updateCategory(
      widget.category!.categoryId,
      name: name,
      colorCode: _selectedColor,
    );
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
                  color: kCategoryDefaultColor,
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
                                    width: _selectedColor.value == color.value
                                        ? 2
                                        : 0),
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
