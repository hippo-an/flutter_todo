import 'package:flutter/material.dart';
import 'package:todo_todo/widget/todo_item.dart';
import 'package:todo_todo/widget/todo_list.dart';

class Todo extends StatelessWidget {
  const Todo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Column(
          children: [
            SafeArea(
              child: AppBar(
                title: const Text('TodoTodo'),
              ),
            ),
            const TodoList(),
            SafeArea(
              child: BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.add),
                    label: 'add',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_month_rounded),
                    label: 'Calendar',
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
