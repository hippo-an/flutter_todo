import 'package:flutter/material.dart';

class TodoItem extends StatefulWidget {
  String title;
  bool isDone;
  String? shortDescription;

  TodoItem({
    super.key,
    required this.title,
    this.shortDescription,
    this.isDone = false,
  });

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {

  void isDone(bool value) {
    setState(() {
      widget.isDone = value;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              value: widget.isDone,
              onChanged: (value) {
                isDone(value!);
              },
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      color: widget.isDone ? Colors.grey : Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decoration: widget.isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  if (widget.shortDescription != null)
                    Text(
                      widget.shortDescription!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
