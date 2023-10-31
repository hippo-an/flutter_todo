import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/colors.dart';
import 'package:todo_todo/constants.dart';
import 'package:todo_todo/controller/category_controller.dart';
import 'package:todo_todo/controller/task_controller.dart';
import 'package:todo_todo/models/category_model.dart';
import 'package:todo_todo/models/subtask_form_model.dart';
import 'package:todo_todo/models/subtask_model.dart';
import 'package:todo_todo/models/task_model.dart';
import 'package:todo_todo/utils.dart';
import 'package:todo_todo/widgets/animated_check_box.dart';
import 'package:todo_todo/widgets/category_select_dialog.dart';
import 'package:todo_todo/widgets/sub_task_form_list.dart';

class TaskDetail extends StatefulWidget {
  const TaskDetail({
    super.key,
    required this.task,
    CategoryModel? category,
  });

  final TaskModel task;

  @override
  State<TaskDetail> createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  final _taskNameFormKey = GlobalKey<FormState>();
  final _subtasksFormKey = GlobalKey<FormState>();
  late final TextEditingController _taskNameController;
  late TextEditingController _noteController;
  late bool _isDone;
  late DateTime? _dueDate;
  late List<SubtaskFormModel> _subtaskFormList;
  late CategoryModel _category;
  late String _taskNameTemp;
  late String _noteTemp;

  bool _categoryLoading = false;
  bool _subtasksLoading = false;

  bool _checkLoading = false;

  @override
  void initState() {
    _taskNameController = TextEditingController(text: widget.task.taskName);
    _noteController = TextEditingController(text: widget.task.note);
    _isDone = widget.task.isDone;
    _dueDate = widget.task.dueDate;
    _subtaskFormList = [
      ...widget.task.subtasks
          .map(
            (subtaskModel) => subtaskModel.toSubTaskFormModel(),
          )
          .toList()
    ];
    _taskNameTemp = _taskNameController.text.trim();
    _noteTemp = _noteController.text.trim();

    final category = Provider.of<CategoryController>(context, listen: false)
        .findSeenCategory(widget.task.categoryId);

    setState(() {
      _category = category;
    });
    super.initState();
  }

  // @override
  // void didUpdateWidget(covariant TaskDetail oldWidget) {
  //   _taskNameController.text = widget.task.taskName;
  //   _noteController.text = widget.task.note ?? '';
  //   _isDone = widget.task.isDone;
  //   _dueDate = widget.task.dueDate;
  //   _subtaskList = [...widget.task.subtasks];
  //   _subtaskFormList = [..._subtaskFormList];
  //   final category = Provider.of<CategoryController>(context, listen: false)
  //       .category(widget.task.categoryId);
  //
  //   setState(() {
  //     _category = category;
  //   });
  //
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  void dispose() {
    _taskNameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  bool _isBefore() {
    final now = DateTime.now();
    return _dueDate!.year < now.year ||
        (_dueDate!.year == now.year && _dueDate!.month < now.month) ||
        (_dueDate!.year == now.year &&
            _dueDate!.month == now.month &&
            _dueDate!.day < now.day);
  }

  Future<void> _categorySelectDialog() async {
    final category = await showDialog<CategoryModel>(
      context: context,
      builder: (context) {
        return const CategorySelectDialog();
      },
    );

    if (category != null && category != _category) {
      await _updateCategory(category);
    }
  }

  Future<void> _updateCategory(CategoryModel category) async {
    setState(() {
      _categoryLoading = true;
    });

    await Provider.of<TaskController>(context, listen: false).updateCategory(
      context,
      taskId: widget.task.taskId,
      categoryId: category.categoryId,
      oldCategoryId: _category.categoryId,
    );

    setState(() {
      _categoryLoading = false;
      _category = category;
    });
  }

  Future<void> _dateSelectDialog() async {
    final dueDate = _dueDate ?? DateTime.now();
    final selectedDueDate = await showDatePicker(
      context: context,
      initialDate: dueDate,
      firstDate: firstDay,
      lastDate: lastDay,
      cancelText: 'Reset',
    );
    await _updateDueDate(selectedDueDate);
  }

  Future<void> _updateDueDate(DateTime? selectedDueDate) async {
    await Provider.of<TaskController>(context, listen: false).updateDueDate(
      context,
      taskId: widget.task.taskId,
      dueDate: selectedDueDate,
    );

    setState(() {
      _dueDate = selectedDueDate;
    });
  }

  Future<void> _updateIsDone(bool value) async {
    if (_isDone != value) {
      setState(() {
        _checkLoading = true;
      });

      await Provider.of<TaskController>(context, listen: false)
          .updateTaskToDone(
        context,
        taskId: widget.task.taskId,
        done: value,
      );

      setState(() {
        _isDone = value;
        _checkLoading = false;
      });
    }
  }

  Future<void> _updateTaskName(PointerDownEvent event) async {
    FocusManager.instance.primaryFocus?.unfocus();

    final taskNameValue = _taskNameController.text.trim();
    if ((_taskNameFormKey.currentState?.validate() ?? false) &&
        _taskNameTemp != taskNameValue) {
      await Provider.of<TaskController>(context, listen: false).updateTaskName(
        context,
        taskId: widget.task.taskId,
        taskName: taskNameValue,
      );

      setState(() {
        _taskNameTemp = taskNameValue;
      });
    }
  }

  Future<void> _updateNote(PointerDownEvent event) async {
    FocusManager.instance.primaryFocus?.unfocus();

    final noteValue = _noteController.text.trim();
    if (_noteTemp != noteValue) {
      await Provider.of<TaskController>(context, listen: false).updateNote(
        context,
        taskId: widget.task.taskId,
        note: noteValue,
      );

      setState(() {
        _noteTemp = noteValue;
      });
    }
  }

  Future<void> _updateSubtasks() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!(_subtasksFormKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _subtasksLoading = true;
    });

    await Provider.of<TaskController>(context, listen: false).updateSubtasks(
      context,
      taskId: widget.task.taskId,
      subtasks: _subtaskFormList
          .map((subtaskForm) => SubtaskModel.fromSubTaskFormModel(subtaskForm))
          .toList(),
    );

    setState(() {
      _subtasksLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.035,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: _category.color, width: 2),
                        ),
                        onPressed: _categorySelectDialog,
                        clipBehavior: Clip.hardEdge,
                        child: _categoryLoading
                            ? const SizedBox(
                                height: 8,
                                width: 8,
                                child: CircularProgressIndicator(),
                              )
                            : Text(
                                _category.isDefault
                                    ? 'No Category'
                                    : _category.name,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: _category.color),
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                              ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2),
                        ),
                        onPressed: _dateSelectDialog,
                        child: _dueDate != null
                            ? Text(
                                formatDate(_dueDate!),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _isBefore() ? kRedColor : kGreyColor,
                                ),
                              )
                            : const Text(
                                'No Date',
                                style: TextStyle(
                                  fontSize: 11,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    AnimatedCheckBox(
                      key: ValueKey(widget.task.taskId),
                      value: _isDone,
                      onChanged: _updateIsDone,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Form(
                key: _taskNameFormKey,
                child: TextFormField(
                  controller: _taskNameController,
                  scrollPadding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                  ),
                  maxLines: 2,
                  maxLength: 50,
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: 'Enter the task.'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Fill the blank.';
                    }

                    if (value.trim().length < 2) {
                      return 'Minimum 2 characters need.';
                    }

                    return null;
                  },
                  onTapOutside: _updateTaskName,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Form(
                key: _subtasksFormKey,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: SubTaskFormList(
                    subtaskForms: _subtaskFormList,
                    onRemove: (index) {
                      setState(() {
                        _subtaskFormList.removeAt(index);
                      });
                    },
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      if (_subtaskFormList.length < 6) {
                        setState(() {
                          _subtaskFormList.add(
                            SubtaskFormModel(
                              subtaskId: uuidV4.generate(),
                            ),
                          );
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.add,
                      size: 22,
                    ),
                    label: const Text('Add subtask'),
                  ),
                  ElevatedButton(
                    onPressed: _updateSubtasks,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: _subtasksLoading
                        ? const SizedBox(
                            height: 8,
                            width: 8,
                            child: CircularProgressIndicator(),
                          )
                        : const Text('Save subtask'),
                  ),
                ],
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    const SizedBox(width: 4),
                    Expanded(
                      child: TextField(
                        scrollPadding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                        ),
                        controller: _noteController,
                        maxLength: 120,
                        maxLines: 3,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          label: const Row(
                            children: [
                              Icon(Icons.note_alt_rounded),
                              SizedBox(width: 8),
                              Text('Note'),
                            ],
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onPrimary,
                          )),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onPrimary,
                          )),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onPrimary,
                          )),
                        ),
                        onTapOutside: _updateNote,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
