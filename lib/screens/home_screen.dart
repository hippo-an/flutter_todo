import 'package:flutter/material.dart';
import 'package:todo_todo/components/main_calendar.dart';
import 'package:todo_todo/models/datas.dart';

class HomeScreen extends StatelessWidget {
  final tasks = dummyTasks;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calendar',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SafeArea(
        child: Column(
          children: [
            MainCalendar(
              selectedDate: DateTime.now(),
              onDaySelected: (DateTime selectedDay, DateTime focusedDay) => {},
            ),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (ctx, idx) {
                  return tasks[idx];
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
