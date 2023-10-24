import 'package:flutter/material.dart';

class TodoLogo extends StatelessWidget {
  const TodoLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      child: const Center(
        child: Text(
          'Flutter Todo',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
