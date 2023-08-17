import 'package:flutter/material.dart';
import 'package:todo_todo/models/enums.dart';

class TaskCard extends StatefulWidget {
  final String name;
  final String? note;
  final Urgent urgent;
  final Importance importance;
  final Priority priority;
  final Progression progression;

  const TaskCard({
    super.key,
    required this.name,
    this.note,
    this.urgent = Urgent.notUrgent,
    this.importance = Importance.notImportance,
    this.priority = Priority.normal,
    this.progression = Progression.ready,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  var _isDone = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          strokeAlign: 0,
          width: 1,
          color: Theme.of(context).colorScheme.primary,
        ),
        shape: BoxShape.rectangle,
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              value: _isDone,
              onChanged: (value) {
                setState(() {
                  _isDone = value ?? false;
                });
              },
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(
                      color: _isDone
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.secondary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decoration: _isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  if (widget.note != null)
                    Text(
                      widget.note ?? 'none',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.secondary,
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
