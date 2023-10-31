import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/constants.dart';
import 'package:todo_todo/controller/calendar_selected_date_controller.dart';
import 'package:todo_todo/controller/category_controller.dart';
import 'package:todo_todo/locator.dart';
import 'package:todo_todo/models/task_model.dart';
import 'package:todo_todo/repository/auth_repository.dart';
import 'package:todo_todo/widgets/task_list_item.dart';

class CalendarTaskListForPaging extends StatefulWidget {
  const CalendarTaskListForPaging({super.key});

  @override
  State<CalendarTaskListForPaging> createState() => _CalendarTaskListForPagingState();
}

class _CalendarTaskListForPagingState extends State<CalendarTaskListForPaging> {
  bool _allFetched = false;
  bool _isLoading = false;
  List<TaskModel> _selectedDateTasks = [];
  DocumentSnapshot? _lastDocument;

  @override
  void initState() {
    print('calendar task init %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    super.initState();
    initTasks();
  }


  @override
  void didUpdateWidget(CalendarTaskListForPaging oldWidget) {
    print('calendar task did update widget %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');

    super.didUpdateWidget(oldWidget);
    initTasks();
  }

  Future<void> initTasks() async {
    if (_isLoading) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    Query<Map<String, dynamic>> query = FirebaseFirestore.instance
        .collection('tasks')
        .where('uid', isEqualTo: locator<AuthRepository>().currentUser.uid)
        .where('isDeleted', isEqualTo: false)
        .where('categoryId',
            whereIn: Provider.of<CategoryController>(
              context,
              listen: false,
            ).seenCategoryIds)
        .where('dueDate',
            isEqualTo: Provider.of<CalendarSelectedDateController>(
              context,
              listen: false,
            ).selectedDate);

    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!).limit(pageSize);
    } else {
      query = query.limit(pageSize);
    }

    final List<TaskModel> pagedTask = await query.get().then((value) {
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
      _selectedDateTasks.addAll(pagedTask);
      if (pagedTask.length < pageSize) {
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

    return Expanded(
      child: ListView.builder(
        itemCount: _selectedDateTasks.length + (_allFetched ? 0 : 1),
        itemBuilder: (context, index) {
          if (index == _selectedDateTasks.length) {
            return const SizedBox(
              key: ValueKey('Loader'),
              width: double.infinity,
              height: 60,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          final task = _selectedDateTasks[index];
          return TaskListItem(
            task: task,
          );
        },
      ),
    );
  }
}
