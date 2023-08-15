import 'package:todo_todo/models/enums.dart';
import 'package:todo_todo/widget/task.dart';

final dummyTasks = [
  const Task(name: 'buy milk', note: 'go to the market',),
  const Task(
    name: 'study flutter',
    priority: Priority.strongest,
    note: 'udemy lecture',
  ),
  const Task(
    name: 'create nice app',
    importance: Importance.importance,
    note: 'create todo app to deploy',
  ),
  const Task(
    name: 'study cloud',
    priority: Priority.strong,
    note: 'flutter is so good to learn',
  ),
];
