import 'package:todo_todo/components/task_card.dart';
import 'package:todo_todo/models/enums.dart';

final dummyTasks = [
  const TaskCard(name: 'buy milk', note: 'go to the market',),
  const TaskCard(
    name: 'study flutter',
    priority: Priority.strongest,
    note: 'udemy lecture',
  ),
  const TaskCard(
    name: 'create nice app',
    importance: Importance.importance,
    note: 'create todo app to deploy',
  ),
  const TaskCard(
    name: 'study cloud',
    priority: Priority.strong,
    note: 'flutter is so good to learn',
  ),
];
