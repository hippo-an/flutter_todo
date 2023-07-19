import 'package:flutter/material.dart';
import 'package:todo_todo/widget/todo/todo.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Todo Todo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const Todo(),
    )
  );
}