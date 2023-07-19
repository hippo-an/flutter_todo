import 'package:flutter/material.dart';
import 'package:todo_todo/widget/todo/todo_add_modal.dart';
import 'package:todo_todo/widget/todo/todo_item.dart';
import 'package:todo_todo/widget/todo/todo_list.dart';

class Todo extends StatefulWidget {
  const Todo({super.key});

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  final List<TodoItem> _todoItems = [
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

  void _openAddTodoModal(BuildContext context) {
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      builder: (ctx) {
        return TodoAddModal(onTodoAdd: _addTodoItem);
      },
    );
  }

  void _addTodoItem(TodoItem item) {
    setState(() {
      _todoItems.add(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            child: AppBar(
              title: const Text('TodoTodo'),
            ),
          ),
          TodoList(
            todoItems: _todoItems,
          ),
          SafeArea(
            child: BottomAppBar(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.settings),
                  ),
                  IconButton(
                    onPressed: () {
                      _openAddTodoModal(context);
                    },
                    icon: const Icon(Icons.add),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.calendar_month_rounded),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
