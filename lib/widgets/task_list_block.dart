import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_todo/archive/locator.dart';
import 'package:todo_todo/controller/task_tab_open_controller.dart';
import 'package:todo_todo/enums.dart';
import 'package:todo_todo/models/task_model.dart';
import 'package:todo_todo/screens/task_detail_screen.dart';
import 'package:todo_todo/widgets/slidable_task_list_item.dart';

class TaskListBlock extends StatefulWidget {
  const TaskListBlock({
    super.key,
    required this.tasks,
    required this.taskListBlockState,
    this.open = false,
  });

  final List<TaskModel> tasks;
  final TaskListBlockState taskListBlockState;
  final bool open;

  @override
  State<TaskListBlock> createState() => _TaskListBlockState();
}

class _TaskListBlockState extends State<TaskListBlock> {
  late bool _open;

  @override
  void initState() {
    _open = widget.open;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            setState(() {
              _open = locator<TaskTabOpenController>()
                  .changeState(widget.taskListBlockState);
            });
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: _open
                    ? const Icon(Icons.arrow_drop_up)
                    : const Icon(Icons.arrow_drop_down),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.taskListBlockState.mappingValue,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${widget.tasks.length} items',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _open
            ? SizedBox(
                height: MediaQuery.of(context).size.height *
                    0.09 *
                    widget.tasks.length,
                child: ListView.builder(
                  itemCount: widget.tasks.length,
                  itemBuilder: (context, index) {
                    final TaskModel task = widget.tasks[index];
                    return GestureDetector(
                      onTap: () {
                        context.push(
                          TaskDetailScreen.routeName,
                          extra: task,
                        );
                      },
                      child: SlidableTaskListItem(
                        key: ValueKey(task.taskId),
                        task: task,
                      ),
                    );
                  },
                ),
              )
            : const SizedBox.shrink()
      ],
    );
  }
}
