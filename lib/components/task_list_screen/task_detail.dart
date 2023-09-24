import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/components/common/category_select_dialog.dart';
import 'package:todo_todo/components/common/sub_task_form_list.dart';
import 'package:todo_todo/consts/tools.dart';
import 'package:todo_todo/models/category_model.dart';
import 'package:todo_todo/models/sub_task_form_model.dart';
import 'package:todo_todo/models/sub_task_model.dart';
import 'package:todo_todo/models/task_model.dart';
import 'package:todo_todo/provider/category_list_provider.dart';
import 'package:todo_todo/provider/task_list_provider.dart';

class TaskDetail extends StatefulWidget {
  const TaskDetail({
    super.key,
    required this.task,
  });

  final TaskModel task;

  @override
  State<TaskDetail> createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  final _formKey = GlobalKey<FormState>();
  late bool _isDone;
  late TextEditingController _taskNameController;
  late TextEditingController _noteController;
  CategoryModel? _categoryModel;
  DateTime? _dueDate;
  late List<SubTaskModel> _subTaskList;
  late List<SubTaskFormModel> _subTaskFormList;
  late ImagePicker? _imagePicker;
  File? _attachment;

  @override
  void initState() {
    super.initState();
    _isDone = widget.task.isDone;
    _taskNameController = TextEditingController(text: widget.task.taskName);
    _noteController = TextEditingController(text: widget.task.note);
    _categoryModel = widget.task.categoryModel;
    _dueDate = widget.task.dueDate;
    _subTaskList = [...widget.task.subTasks];
    _subTaskFormList = [];
    _imagePicker = ImagePicker();
    _attachment = widget.task.attachment;
  }

  @override
  void didUpdateWidget(covariant TaskDetail oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _dateSelectDialog() async {
    final dueDate = _dueDate ?? DateTime.now();
    final selectedDueDate = await showDatePicker(
      context: context,
      initialDate: dueDate,
      firstDate: DateTime(dueDate.year - 20),
      lastDate: DateTime(dueDate.year + 20),
      cancelText: 'Reset',
    );

    setState(() {
      _dueDate = selectedDueDate;
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
        _categoryModel = null;
      });
    } else {
      setState(() {
        _categoryModel =
            Provider.of<CategoryListProvider>(context, listen: false)
                .findCategory(id);
      });
    }
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      Provider.of<TaskListProvider>(context, listen: false).updateTask(
        task: widget.task,
        taskName: _taskNameController.text.trim(),
        isDone: _isDone,
        completedDate: _isDone ? DateTime.now() : null,
        categoryModel: _categoryModel,
        subTasks: [
          ..._subTaskList,
          ..._subTaskFormList
              .map((subTaskForm) =>
                  SubTaskModel.fromSubTaskFormModel(subTaskForm))
              .toList()
        ],
        dueDate: _dueDate,
        note: _noteController.text.trim(),
        attachment: _attachment,
      );
      Navigator.of(context).pop();
    }
  }

  bool _isBefore() {
    final now = DateTime.now();
    return _dueDate!.year < now.year ||
        (_dueDate!.year == now.year && _dueDate!.month < now.month) ||
        (_dueDate!.year == now.year &&
            _dueDate!.month == now.month &&
            _dueDate!.day < now.day);
  }

  void _selectAttachmentImage() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick the source'),
          actions: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_attachment != null)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _attachment = null;
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text('Clear'),
                  ),
                ElevatedButton.icon(
                  onPressed: () async {
                    final pickedImage = await _imagePicker!.pickImage(
                      source: ImageSource.gallery,
                      maxHeight: 800,
                      maxWidth: 600,
                    );
                    if (pickedImage == null) {
                      return;
                    }
                    final file = File(pickedImage.path);

                    if (file.readAsBytesSync().length > 10485760 && mounted) {
                      ScaffoldMessenger.of(context)
                        ..clearSnackBars()
                        ..showSnackBar(
                          const SnackBar(
                            content: Text('Image is over 10MB'),
                          ),
                        );
                      return;
                    }

                    if (mounted) {
                      setState(() {
                        _attachment = file;
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  icon: const Icon(Icons.image),
                  label: const Text('Gallery'),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    final pickedImage = await _imagePicker!.pickImage(
                      source: ImageSource.camera,
                      maxHeight: 800,
                      maxWidth: 600,
                    );
                    if (pickedImage == null) {
                      return;
                    }
                    final file = File(pickedImage.path);

                    if (file.readAsBytesSync().length > 10485760 && mounted) {
                      ScaffoldMessenger.of(context)
                        ..clearSnackBars()
                        ..showSnackBar(
                          const SnackBar(
                            content: Text('Image is over 10MB'),
                          ),
                        );
                      return;
                    }

                    if (mounted) {
                      setState(() {
                        _attachment = file;
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: const Text('Camera'),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final pop = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: const Text('You will lose changes.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Leave'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Stay'),
              ),
            ],
          ),
        );

        return pop ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _isDone = !_isDone;
                });
              },
              icon: Icon(_isDone
                  ? Icons.radio_button_unchecked
                  : Icons.check_circle_outline),
              label: Text(_isDone ? 'Mark unfinished' : 'Mark finished'),
            ),
            TextButton.icon(
              onPressed: _onSave,
              icon: const Icon(Icons.save_alt),
              label: const Text('Save'),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.035,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: OutlinedButton(
                                onPressed: _categorySelectDialog,
                                clipBehavior: Clip.hardEdge,
                                child: Text(
                                  _categoryModel == null
                                      ? 'No Category'
                                      : _categoryModel!.name,
                                  style: const TextStyle(
                                    fontSize: 11,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 2,
                              child: OutlinedButton(
                                onPressed: _dateSelectDialog,
                                child: _dueDate != null
                                    ? Text(
                                        '${_dueDate!.year}-${_dueDate!.month.toString().padLeft(2, '0')}-${_dueDate!.day.toString().padLeft(2, '0')}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: _isBefore()
                                              ? Colors.red[300]
                                              : Colors.grey[500],
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
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _taskNameController,
                        maxLines: 2,
                        maxLength: 50,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter the task.'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Fill the blank.';
                          }

                          return null;
                        },
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_subTaskList.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: SubTaskFormList(
                            subTaskForms: _subTaskList
                                .map(
                                  (subTaskModel) =>
                                      subTaskModel.toSubTaskFormModel(),
                                )
                                .toList(),
                            onRemove: (index) {
                              setState(() {
                                _subTaskList.removeAt(index);
                              });
                            },
                          ),
                        ),
                      if (_subTaskFormList.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: SubTaskFormList(
                            subTaskForms: _subTaskFormList,
                            onRemove: (index) {
                              setState(() {
                                _subTaskFormList.removeAt(index);
                              });
                            },
                          ),
                        ),
                      TextButton.icon(
                        onPressed: () {
                          if (_subTaskFormList.length + _subTaskList.length <
                              6) {
                            setState(() {
                              _subTaskFormList.add(
                                SubTaskFormModel(
                                  subTaskId: uuid.generate(),
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
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const SizedBox(width: 4),
                            Expanded(
                              child: TextFormField(
                                controller: _noteController,
                                maxLength: 120,
                                maxLines: 3,
                                decoration: const InputDecoration(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
                                  label: Row(
                                    children: [
                                      Icon(Icons.note_alt_rounded),
                                      Text('Note'),
                                    ],
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      _attachment != null
                          ? GestureDetector(
                              onTap: _selectAttachmentImage,
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                width: MediaQuery.of(context).size.width,
                                child: Image.file(
                                  _attachment!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Row(
                              children: [
                                TextButton.icon(
                                  onPressed: _selectAttachmentImage,
                                  icon: const Icon(Icons.image),
                                  label: const Text('Attachment'),
                                ),
                                const Text(
                                  'One image under 10MB available.',
                                  style: TextStyle(color: Colors.grey),
                                )
                              ],
                            ),
                    ],
                  ),
                ),
              ),
              _isDone
                  ? Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.6),
                      ),
                    )
                  : const SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }
}
