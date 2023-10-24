import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/colors.dart';
import 'package:todo_todo/controller/category_controller.dart';
import 'package:todo_todo/models/category_model.dart';

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
  late final TextEditingController _categoryController;
  late Color _selectedColor;
  bool _isLoading = false;

  @override
  void initState() {
    _categoryController = TextEditingController();

    if (widget.isEditMode && widget.category != null) {
      _categoryController.text = widget.category!.name;
    }

    _selectedColor = widget.category?.color ?? kDefaultCategoryColorSet[0];
    super.initState();
  }

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _onCreate() async {
    final name = _categoryController.text.trim();
    if (name.isEmpty) {
      _categoryController.clear();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Provider.of<CategoryController>(context, listen: false)
        .createCategory(name);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _onUpdate() {
    // final name = _categoryController.text.trim();
    // if (name.isEmpty) {
    //   _categoryController.clear();
    //   return;
    // }
    //
    // if (widget.category != null &&
    //     name == widget.category!.name &&
    //     _selectedColor == widget.category!.color) {
    //   return;
    // }
    //
    // locator<CategoryViewModel>().updateCategory(
    //   widget.category!.categoryId,
    //   name: name,
    //   colorCode: _selectedColor,
    // );
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      title: Text(
        widget.isEditMode ? 'Edit category' : 'New category',
      ),
      titleTextStyle: const TextStyle(
        fontSize: 18,
        color: kWhiteColor,
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
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.secondary,
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
              children: kDefaultCategoryColorSet
                  .map(
                    (color) => GestureDetector(
                      onTap: () {
                        if (_selectedColor == color) {
                          return;
                        }

                        setState(() {
                          _selectedColor = color;
                        });
                      },
                      child: SizedBox(
                        height: 25,
                        width: 25,
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: _selectedColor.value == color.value
                                      ? 3
                                      : 0),
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              backgroundColor: color,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading
              ? () {}
              : () {
                  Navigator.of(context).pop();
                },
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: kWhiteColor,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _isLoading
              ? null
              : widget.isEditMode
                  ? _onUpdate
                  : _onCreate,
          child: _isLoading
              ? const SizedBox(
                  height: 10,
                  width: 10,
                  child: CircularProgressIndicator(
                    color: kWhiteColor,
                  ),
                )
              : const Text("Save"),
        ),
      ],
    );
  }
}
