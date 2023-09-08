import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/screens/task_add_screen.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Provider(create: (BuildContext context) {  },
                child: const TaskAddScreen()),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(4),
        height: 50,
        width: 50,
        decoration: const BoxDecoration(
          color: Colors.black12,
          shape: BoxShape.circle,
        ),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
