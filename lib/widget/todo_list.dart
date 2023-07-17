import 'package:flutter/material.dart';
import 'package:todo_todo/widget/todo_item.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<StatefulWidget> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<TodoItem> _todoItems = [
    TodoItem(
      title: 'Buy milk',
      shortDescription: 'Buy milk from the store',
    ),
    TodoItem(
      title: 'Buy eggs',
      shortDescription: 'Buy eggs from the store',
    ),
    TodoItem(
      title: 'Buy bread',
      shortDescription: 'Buy bread from the store',
      isDone: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: _todoItems.length,
        itemBuilder: (ctx, idx) => _todoItems[idx],
      ),
    );
  }
}
