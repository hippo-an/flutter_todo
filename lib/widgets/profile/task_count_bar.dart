import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/controller/category_controller.dart';
import 'package:todo_todo/locator.dart';
import 'package:todo_todo/repository/auth_repository.dart';
import 'package:todo_todo/repository/task_repository.dart';
import 'package:todo_todo/widgets/profile/base_card.dart';

class TaskCountBar extends StatelessWidget {
  const TaskCountBar({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Row(
      children: [
        Expanded(
          child: BaseCard(
            width: size.width,
            height: size.height * 0.15,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _CompletedTasksFuture(),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Completed Tasks',
                  style: TextStyle(fontSize: 12),
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: BaseCard(
            width: size.width,
            height: size.height * 0.15,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _PendingTasksFuture(),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Pending Tasks',
                  style: TextStyle(fontSize: 12),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CompletedTasksFuture extends StatelessWidget {
  const _CompletedTasksFuture({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: locator<TaskRepository>().completeCount(
          uid: locator<AuthRepository>().currentUser.uid,
          categoryIds: Provider.of<CategoryController>(context,
              listen: false)
              .seenCategoryIds),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong.'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasData) {
          return Text(
            '${snapshot.data!}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          );
        }

        return const Center(
          child: Text('Something went wrong.'),
        );
      },
    );
  }
}

class _PendingTasksFuture extends StatelessWidget {
  const _PendingTasksFuture({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: locator<TaskRepository>().pendingTasks(
          uid: locator<AuthRepository>().currentUser.uid,
          categoryIds: Provider.of<CategoryController>(context,
              listen: false)
              .seenCategoryIds),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong.'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasData) {
          return Text(
            '${snapshot.data!}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          );
        }

        return const Center(
          child: Text('Something went wrong.'),
        );
      },
    );
  }
}

