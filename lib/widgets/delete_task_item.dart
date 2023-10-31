import 'package:flutter/material.dart';
import 'package:todo_todo/colors.dart';
import 'package:todo_todo/models/task_model.dart';
import 'package:todo_todo/utils.dart';

class DeleteTaskItem extends StatefulWidget {
  const DeleteTaskItem({
    super.key,
    required this.task,
    required this.onReturn,
    required this.onDelete,
  });

  final TaskModel task;
  final Future<void> Function() onReturn;
  final Future<void> Function() onDelete;

  @override
  State<DeleteTaskItem> createState() => _DeleteTaskItemState();
}

class _DeleteTaskItemState extends State<DeleteTaskItem> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: _isLoading,
      child: Container(
        margin: const EdgeInsets.only(bottom: 2),
        height: MediaQuery.of(context).size.height * 0.08,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onBackground,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.task.taskName,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      maxLines: 1,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                    widget.task.dueDate != null
                        ? const SizedBox(height: 12)
                        : const SizedBox.shrink(),
                    if (widget.task.dueDate != null)
                      Text(
                        dashFormatDate(widget.task.dueDate!),
                        style: TextStyle(
                          fontSize: 12,
                          color: widget.task.isBeforeThanToday
                              ? kRedColor
                              : kGreyColor,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            _isLoading
                ? const SizedBox(
                    height: 14,
                    width: 14,
                    child: CircularProgressIndicator(),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        padding: const EdgeInsets.all(4),
                        splashColor: Colors.transparent,
                        splashRadius: 16,
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          await widget.onReturn().then((value) {
                            setState(() {
                              _isLoading = false;
                            });
                          });
                        },
                        icon: const Icon(
                          Icons.refresh_outlined,
                          size: 18,
                        ),
                      ),
                      IconButton(
                        padding: const EdgeInsets.all(4),
                        splashColor: Colors.transparent,
                        splashRadius: 16,
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          await widget.onDelete().then((value) {
                            setState(() {
                              _isLoading = false;
                            });
                          });
                        },
                        icon: const Icon(
                          Icons.delete_forever_sharp,
                          color: Colors.red,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
            SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}
