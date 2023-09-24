import 'package:flutter/material.dart';

class TodoListContainer extends StatelessWidget {
  const TodoListContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) => CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          side: const BorderSide(),
          checkboxShape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text('$index'),
          value: false,
          onChanged: (bool? value) {},
        ),
      ),
    );
  }
}
