import 'package:flutter/material.dart';
import 'package:todo_todo/widget/todo/todo_item.dart';

class TodoList extends StatelessWidget {
  final List<TodoItem> todoItems;
  const TodoList({super.key, required this.todoItems});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: todoItems.length,
        itemBuilder: (ctx, idx) => todoItems[idx],
      ),
    );
  }
}
