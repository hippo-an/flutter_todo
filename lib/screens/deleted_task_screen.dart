import 'package:flutter/material.dart';
import 'package:todo_todo/widgets/deleted_task_list.dart';

class DeletedTaskScreen extends StatelessWidget {

  static const String routeName = '/deleted-task';
  const DeletedTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Deleted tasks'),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: const DeletedTaskList(),
        ),
      ),
    );
  }
}
