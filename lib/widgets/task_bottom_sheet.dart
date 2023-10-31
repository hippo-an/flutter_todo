import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/constants.dart';
import 'package:todo_todo/controller/category_controller.dart';
import 'package:todo_todo/controller/task_controller.dart';
import 'package:todo_todo/models/category_model.dart';
import 'package:todo_todo/models/subtask_form_model.dart';
import 'package:todo_todo/models/subtask_model.dart';
import 'package:todo_todo/utils.dart';
import 'package:todo_todo/widgets/category_select_dialog.dart';
import 'package:todo_todo/widgets/sub_task_form_list.dart';

import '../colors.dart';

class TaskBottomSheet extends StatefulWidget {
  const TaskBottomSheet({
    super.key,
  });

  @override
  State<TaskBottomSheet> createState() => _TaskBottomSheetState();
}

class _TaskBottomSheetState extends State<TaskBottomSheet> {
  late CategoryModel? _category;
  DateTime? _selectedDate;
  late final List<SubtaskFormModel> _subtaskForms;
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _taskNameController;

  bool _isLoading = false;

  @override
  void initState() {
    final categoryController =
        Provider.of<CategoryController>(context, listen: false);
    final selectedCategory = categoryController.selectedCategory;
    _category = selectedCategory == null || selectedCategory.isDefault
        ? null
        : selectedCategory;
    _selectedDate = DateTime.now().toUtc();
    _subtaskForms = [];
    _formKey = GlobalKey<FormState>();
    _taskNameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    super.dispose();
  }

  Future<void> _dateSelectDialog() async {
    final now = _selectedDate ?? DateTime.now().toUtc();
    final dateTime = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDay,
      lastDate: lastDay,
      cancelText: 'Reset',
    );

    setState(() {
      _selectedDate = dateTime;
    });
  }

  void _categorySelectDialog() async {
    final category = await showDialog<CategoryModel>(
      context: context,
      builder: (context) {
        return const CategorySelectDialog();
      },
    );

    if (category != null) {
      if (mounted) {
        _category = category;
      }
    }

    setState(() {});
  }

  void _onRemove(int index) {
    setState(() {
      _subtaskForms.removeAt(index);
    });
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      FocusManager.instance.primaryFocus?.unfocus();
      final List<SubtaskModel> subtasks = _subtaskForms
          .map((subtaskForm) => SubtaskModel.fromSubTaskFormModel(subtaskForm))
          .toList();

      setState(() {
        _isLoading = true;
      });

      final success = await Provider.of<TaskController>(context, listen: false).createTask(
        context,
        taskName: _taskNameController.text.trim(),
        dueDate: _selectedDate,
        category: _category,
        subtasks: subtasks,
      );

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        if (success) {
          Navigator.of(context).pop();
        } else {
          showSnackBar(context, 'Create task went wrong..Try again.');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AbsorbPointer(
        absorbing: _isLoading,
        child: SingleChildScrollView(
          child: AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 100),
            curve: Curves.decelerate,
            child: Form(
              key: _formKey,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _taskNameController,
                      autofocus: true,
                      maxLines: 1,
                      maxLength: 50,
                      expands: false,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Input new task here',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        floatingLabelAlignment: FloatingLabelAlignment.start,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: kColorScheme,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: kColorScheme,
                          ),
                        ),
                        labelStyle: const TextStyle(fontSize: 12),
                      ),
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Fill the blank';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    if (_subtaskForms.isNotEmpty)
                      SubTaskFormList(
                        subtaskForms: _subtaskForms,
                        onRemove: _onRemove,
                      ),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.035,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              onPressed: _categorySelectDialog,
                              child: Text(
                                _category == null
                                    ? 'No Category'
                                    : _category!.name,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: kWhiteColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _selectedDate != null
                            ? Expanded(
                                flex: 2,
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.035,
                                  child: OverflowBar(
                                    children: [
                                      OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                        onPressed: _dateSelectDialog,
                                        child: Text(
                                          '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: kWhiteColor,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : IconButton(
                                onPressed: _dateSelectDialog,
                                icon: const Icon(
                                  Icons.calendar_month_sharp,
                                  size: 22,
                                ),
                              ),
                        IconButton(
                          onPressed: () {
                            if (_subtaskForms.length < 6) {
                              setState(() {
                                _subtaskForms.add(
                                  SubtaskFormModel(
                                    subtaskId: uuidV4.generate(),
                                  ),
                                );
                              });
                            }
                          },
                          icon: const Icon(
                            Icons.alt_route,
                            size: 22,
                          ),
                        ),
                        _isLoading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(),
                              )
                            : IconButton(
                                onPressed: _onSubmit,
                                icon: Icon(
                                  Icons.send_sharp,
                                  size: 22,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
