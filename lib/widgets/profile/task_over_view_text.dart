import 'package:flutter/material.dart';

class TaskOverViewText extends StatelessWidget {
  const TaskOverViewText({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width,
      height: 20,
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          'Tasks Overview',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
