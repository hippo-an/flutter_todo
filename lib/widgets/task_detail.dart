import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/colors.dart';
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
        .category(widget.task.categoryId);

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
      firstDate: DateTime(dueDate.year - 20),
      lastDate: DateTime(dueDate.year + 20),
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
      await Provider.of<TaskController>(context, listen: false)
          .updateTaskToDone(
        context,
        taskId: widget.task.taskId,
        done: value,
      );

      setState(() {
        _isDone = value;
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
                              subtaskId: uuid.generate(),
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

//
// void _selectAttachmentImage() async {
//   showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: const Text('Pick the source'),
//         actions: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               if (_attachment != null)
//                 TextButton(
//                   onPressed: () {
//                     setState(() {
//                       _attachment = null;
//                     });
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text('Clear'),
//                 ),
//               ElevatedButton.icon(
//                 onPressed: () async {
//                   final pickedImage = await _imagePicker!.pickImage(
//                     source: ImageSource.gallery,
//                     maxHeight: 800,
//                     maxWidth: 600,
//                   );
//                   if (pickedImage == null) {
//                     return;
//                   }
//                   final file = File(pickedImage.path);
//
//                   if (file.readAsBytesSync().length > 10485760 && mounted) {
//                     ScaffoldMessenger.of(context)
//                       ..clearSnackBars()
//                       ..showSnackBar(
//                         const SnackBar(
//                           content: Text('Image is over 10MB'),
//                         ),
//                       );
//                     return;
//                   }
//
//                   if (mounted) {
//                     setState(() {
//                       _attachment = file;
//                     });
//                     Navigator.of(context).pop();
//                   }
//                 },
//                 icon: const Icon(Icons.image),
//                 label: const Text('Gallery'),
//               ),
//               ElevatedButton.icon(
//                 onPressed: () async {
//                   final pickedImage = await _imagePicker!.pickImage(
//                     source: ImageSource.camera,
//                     maxHeight: 800,
//                     maxWidth: 600,
//                   );
//                   if (pickedImage == null) {
//                     return;
//                   }
//                   final file = File(pickedImage.path);
//
//                   if (file.readAsBytesSync().length > 10485760 && mounted) {
//                     ScaffoldMessenger.of(context)
//                       ..clearSnackBars()
//                       ..showSnackBar(
//                         const SnackBar(
//                           content: Text('Image is over 10MB'),
//                         ),
//                       );
//                     return;
//                   }
//
//                   if (mounted) {
//                     setState(() {
//                       _attachment = file;
//                     });
//                     Navigator.of(context).pop();
//                   }
//                 },
//                 icon: const Icon(Icons.camera_alt_outlined),
//                 label: const Text('Camera'),
//               ),
//             ],
//           )
//         ],
//       );
//     },
//   );
// }
//
// @override
// Widget build(BuildContext context) {
//   return WillPopScope(
//     onWillPop: () async {
//       final pop = await showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           content: const Text('You will lose changes.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(true);
//               },
//               child: const Text('Leave'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop(false);
//               },
//               child: const Text('Stay'),
//             ),
//           ],
//         ),
//       );
//
//       return pop ?? false;
//     },
//     child: Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Task'),
//         actions: [
//           TextButton.icon(
//             onPressed: _onSave,
//             icon: const Icon(Icons.save_alt),
//             label: const Text('Save'),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Stack(
//           children: [
//             _isDone
//                 ? Container(
//                     height: MediaQuery.of(context).size.height,
//                     width: MediaQuery.of(context).size.width,
//                     decoration: BoxDecoration(
//                       color: Colors.grey.withOpacity(0.6),
//                     ),
//                   )
//                 : const SizedBox.shrink(),
//             Container(
//               padding: const EdgeInsets.all(16),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       height: MediaQuery.of(context).size.height * 0.035,
//                       child: Row(
//                         children: [
//                           Expanded(
//                             flex: 1,
//                             child: OutlinedButton(
//                               onPressed: _categorySelectDialog,
//                               clipBehavior: Clip.hardEdge,
//                               child: Text(
//                                 _categoryId == _defaultCategory.categoryId
//                                     ? 'No Category'
//                                     : _categoryName!,
//                                 style: const TextStyle(
//                                   fontSize: 11,
//                                 ),
//                                 overflow: TextOverflow.ellipsis,
//                                 softWrap: true,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             flex: 1,
//                             child: OutlinedButton(
//                               onPressed: _dateSelectDialog,
//                               child: _dueDate != null
//                                   ? Text(
//                                       '${_dueDate!.year}-${_dueDate!.month.toString().padLeft(2, '0')}-${_dueDate!.day.toString().padLeft(2, '0')}',
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         color: _isBefore()
//                                             ? Colors.red[300]
//                                             : Colors.grey[500],
//                                       ),
//                                     )
//                                   : const Text(
//                                       'No Date',
//                                       style: TextStyle(
//                                         fontSize: 11,
//                                       ),
//                                     ),
//                             ),
//                           ),
//                           Checkbox(
//                             value: _isDone,
//                             onChanged: (value) {
//                               setState(() {
//                                 _isDone = !_isDone;
//                               });
//                             },
//                             shape: const CircleBorder(),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     TextFormField(
//                       controller: _taskNameController,
//                       maxLines: 2,
//                       maxLength: 50,
//                       decoration: const InputDecoration(
//                           border: InputBorder.none,
//                           hintText: 'Enter the task.'),
//                       validator: (value) {
//                         if (value == null || value.trim().isEmpty) {
//                           return 'Fill the blank.';
//                         }
//
//                         return null;
//                       },
//                       style: const TextStyle(
//                         fontSize: 16,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     if (_subtaskList.isNotEmpty)
//                       Padding(
//                         padding: const EdgeInsets.only(bottom: 4),
//                         child: SubTaskFormList(
//                           subtaskForms: _subtaskList
//                               .map(
//                                 (subtaskModel) =>
//                                     subtaskModel.toSubTaskFormModel(),
//                               )
//                               .toList(),
//                           onRemove: (index) {
//                             setState(() {
//                               _subtaskList.removeAt(index);
//                             });
//                           },
//                         ),
//                       ),
//                     if (_subtaskFormList.isNotEmpty)
//                       Padding(
//                         padding: const EdgeInsets.only(bottom: 4),
//                         child: SubTaskFormList(
//                           subtaskForms: _subtaskFormList,
//                           onRemove: (index) {
//                             setState(() {
//                               _subtaskFormList.removeAt(index);
//                             });
//                           },
//                         ),
//                       ),
//                     TextButton.icon(
//                       onPressed: () {
//                         if (_subtaskFormList.length + _subtaskList.length <
//                             6) {
//                           setState(() {
//                             _subtaskFormList.add(
//                               SubTaskFormModel(
//                                 subtaskId: uuid.generate(),
//                               ),
//                             );
//                           });
//                         }
//                       },
//                       icon: const Icon(
//                         Icons.add,
//                         size: 22,
//                       ),
//                       label: const Text('Add subtask'),
//                     ),
//                     const Divider(),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 8.0),
//                       child: Row(
//                         children: [
//                           const SizedBox(width: 4),
//                           Expanded(
//                             child: TextFormField(
//                               controller: _noteController,
//                               maxLength: 120,
//                               maxLines: 3,
//                               decoration: const InputDecoration(
//                                 floatingLabelBehavior:
//                                     FloatingLabelBehavior.auto,
//                                 label: Row(
//                                   children: [
//                                     Icon(Icons.note_alt_rounded),
//                                     Text('Note'),
//                                   ],
//                                 ),
//                                 border: OutlineInputBorder(),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     _attachment != null
//                         ? GestureDetector(
//                             onTap: _selectAttachmentImage,
//                             child: SizedBox(
//                               height:
//                                   MediaQuery.of(context).size.height * 0.3,
//                               width: MediaQuery.of(context).size.width,
//                               child: Image.file(
//                                 _attachment!,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Row(
//                             children: [
//                               TextButton.icon(
//                                 onPressed: _selectAttachmentImage,
//                                 icon: const Icon(Icons.image),
//                                 label: const Text('Attachment'),
//                               ),
//                               const Text(
//                                 'One image under 10MB available.',
//                                 style: TextStyle(color: Colors.grey),
//                               )
//                             ],
//                           ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
}
