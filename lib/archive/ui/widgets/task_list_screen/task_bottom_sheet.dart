import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/archive/locator.dart';
import 'package:todo_todo/archive/common/colors.dart';
import 'package:todo_todo/archive/common/tools.dart';
import 'package:todo_todo/models/category_model.dart';
import 'package:todo_todo/archive/core/models/sub_task_form_model.dart';
import 'package:todo_todo/archive/core/models/sub_task_model.dart';
import 'package:todo_todo/archive/core/view_models/category_view_model.dart';
import 'package:todo_todo/archive/core/view_models/task_view_model.dart';
import 'package:todo_todo/archive/ui/shared/category_select_dialog.dart';
import 'package:todo_todo/archive/ui/shared/sub_task_form_list.dart';

class TaskBottomSheet extends StatefulWidget {
  const TaskBottomSheet({
    super.key,
  });

  @override
  State<TaskBottomSheet> createState() => _TaskBottomSheetState();
}

class _TaskBottomSheetState extends State<TaskBottomSheet> {
  late final CategoryModel _defaultCategory;
  late CategoryModel? _category;
  DateTime? _selectedDate;
  late final List<SubTaskFormModel> _subTaskForms;
  late final GlobalKey<FormState> _formKey;
  late TextEditingController _taskNameController;

  @override
  void initState() {
    super.initState();
    _defaultCategory = locator<CategoryViewModel>().defaultCategory;
    _category = locator<CategoryViewModel>().selectedCategory;
    _selectedDate = DateTime.now();
    _subTaskForms = [];
    _formKey = GlobalKey<FormState>();
    _taskNameController = TextEditingController();
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    super.dispose();
  }

  void _dateSelectDialog() async {
    final now = _selectedDate ?? DateTime.now();
    final dateTime = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 10),
      cancelText: 'Reset',
    );

    setState(() {
      _selectedDate = dateTime;
    });
  }

  void _categorySelectDialog() async {
    final (id, name) = await showDialog(
      context: context,
      builder: (context) {
        return const CategorySelectDialog();
      },
    );

    if (id == null && name == null) {
      setState(() {
        _category = _defaultCategory;
      });
    } else {
      setState(() {
        _category = locator<CategoryViewModel>().findCategory(id);
      });
    }
  }

  void _onRemove(int index) {
    setState(() {
      _subTaskForms.removeAt(index);
    });
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      final List<SubTaskModel> subTasks = _subTaskForms.isEmpty
          ? []
          : _subTaskForms
              .map((subTaskForm) =>
                  SubTaskModel.fromSubTaskFormModel(subTaskForm))
              .toList();

      Provider.of<TaskViewModel>(context, listen: false).createTask(
          _taskNameController.text,
          dueDate: _selectedDate,
          // todo
          categoryModel: _category!,
          subTasks: subTasks);

      locator<CategoryViewModel>()
      // todo
          .updateCategory(_category!.categoryId, task: 1);

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(
                          color: kCategoryDefaultColor,
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
                  if (_subTaskForms.isNotEmpty)
                    SubTaskFormList(
                      subTaskForms: _subTaskForms,
                      onRemove: _onRemove,
                    ),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.035,
                          child: OutlinedButton(
                            onPressed: _categorySelectDialog,
                            child: Text(
                              _category == _defaultCategory
                                  ? 'No Category'
                                  : _category!.name,  // todo
                              style: const TextStyle(
                                fontSize: 11,
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
                                height:
                                    MediaQuery.of(context).size.height * 0.035,
                                child: OverflowBar(
                                  children: [
                                    OutlinedButton(
                                      onPressed: _dateSelectDialog,
                                      child: Text(
                                        '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}',
                                        style: const TextStyle(
                                          fontSize: 11,
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
                          if (_subTaskForms.length < 6) {
                            setState(() {
                              _subTaskForms.add(
                                SubTaskFormModel(
                                  subTaskId: uuid.generate(),
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
                      IconButton(
                        onPressed: _onSubmit,
                        icon: const Icon(
                          Icons.send_sharp,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
