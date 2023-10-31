import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/colors.dart';
import 'package:todo_todo/constants.dart';
import 'package:todo_todo/controller/task_controller.dart';
import 'package:todo_todo/locator.dart';
import 'package:todo_todo/models/task_model.dart';
import 'package:todo_todo/repository/auth_repository.dart';
import 'package:todo_todo/widgets/delete_task_item.dart';
import 'package:todo_todo/widgets/task_list_item.dart';

class DeletedTaskList extends StatefulWidget {
  const DeletedTaskList({super.key});

  @override
  State<DeletedTaskList> createState() => _DeletedTaskListState();
}

class _DeletedTaskListState extends State<DeletedTaskList> {
  bool _allFetched = false;
  bool _isLoading = false;
  List<TaskModel> _deletedTasks = [];
  DocumentSnapshot? _lastDocument;

  @override
  void initState() {
    super.initState();
    _fetchFirebaseData();
  }

  Future<void> _fetchFirebaseData() async {
    if (_isLoading) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance
        .collection('tasks')
        .where('uid', isEqualTo: locator<AuthRepository>().currentUser.uid)
        .where('isDeleted', isEqualTo: true)
        .orderBy('deletedAt', descending: true);

    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!).limit(pageSize);
    } else {
      query = query.limit(pageSize);
    }

    final List<TaskModel> pagedData = await query.get().then((value) {
      if (value.docs.isNotEmpty) {
        _lastDocument = value.docs.last;
      } else {
        _lastDocument = null;
      }
      return value.docs
          .map(
            (e) => TaskModel.fromJson(
              e.data(),
            ),
          )
          .toList();
    });

    setState(() {
      _deletedTasks.addAll(pagedData);
      if (pagedData.length < pageSize) {
        _allFetched = true;
      }
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return NotificationListener<ScrollEndNotification>(
      child: ListView.builder(
        itemBuilder: (context, index) {
          if (index == _deletedTasks.length) {
            return const SizedBox(
              key: ValueKey('Loader'),
              width: double.infinity,
              height: 60,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          final task = _deletedTasks[index];
          return DeleteTaskItem(
            key: ValueKey(task.taskId),
            task: task,
            onReturn: () async {
              await Provider.of<TaskController>(context, listen: false)
                  .backTask(
                context,
                taskId: task.taskId,
                categoryId: task.categoryId,
              )
                  .then((value) {
                if (value) {
                  setState(() {
                    _deletedTasks.remove(task);
                  });
                }
              });
            },
            onDelete: () async {
              await showDialog<bool>(
                context: context,
                builder: (context) => const _DeleteAlertDialog(),
              ).then((value) async {
                if (value != null && value) {
                  await Provider.of<TaskController>(context, listen: false)
                      .deleteTaskPermanently(
                    context,
                    taskId: task.taskId,
                  )
                      .then((value) {
                    if (value) {
                      setState(() {
                        _deletedTasks.remove(task);
                      });
                    }
                  });
                }
              });
            },
          );
        },
        itemCount: _deletedTasks.length + (_allFetched ? 0 : 1),
      ),
      onNotification: (scrollEnd) {
        if (scrollEnd.metrics.atEdge && scrollEnd.metrics.pixels > 0) {
          _fetchFirebaseData();
        }
        return true;
      },
    );
  }
}

class _DeleteAlertDialog extends StatelessWidget {
  const _DeleteAlertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete task permanently'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('Cancel'),
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(
              color: kRedColor,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text(
            'Delete',
            style: TextStyle(
              color: kRedColor,
            ),
          ),
        ),
      ],
    );
  }
}
