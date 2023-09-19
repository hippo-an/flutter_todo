import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/models/task_model.dart';
import 'package:todo_todo/provider/category_list_provider.dart';

class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen({
    super.key,
    required this.task,
  });

  final TaskModel task;

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late final TextEditingController _textEditController;

  @override
  void initState() {
    super.initState();
    _textEditController = TextEditingController(text: widget.task.taskName);
  }

  @override
  Widget build(BuildContext context) {
    final categoryListProvider = Provider.of<CategoryListProvider>(context);
    final categories = categoryListProvider.categories;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Task detail')),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (categories.isNotEmpty)
                DropdownButtonHideUnderline(
                  child: DropdownButton(
                    value: widget.task.categoryModel?.name,
                    isExpanded: true,
                    items: categories.map(
                      (category) => DropdownMenuItem(
                        value: category.name,
                        child: Text(
                          category.name,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ).toList(),
                    onChanged: (value) {

                    },
                    hint: Container(
                      child: Text('No Category'),
                    ),
                  ),
                ),
              // DropdownButton(
              //   onTap: () {
              //
              //   },
              //   value: widget.task.categoryModel?.categoryId,
              //   items: categories
              //       .map((category) =>
              //       DropdownMenuItem(
              //         value: category.categoryId,
              //         child: Text(category.name),
              //       ))
              //       .toList(),
              //   onChanged: (value) {},
              // ),
              TextField(
                controller: _textEditController,
                maxLines: 1,
                decoration: const InputDecoration(border: InputBorder.none),
              ),
              const Spacer(),
              const Divider(),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Icon(Icons.calendar_month_sharp),
                    Text('Due Date'),
                    Spacer(),
                    widget.task.dueDate != null
                        ? Text(
                            '${widget.task.dueDate!.year}-${widget.task.dueDate!.month.toString().padLeft(2, '0')}-${widget.task.dueDate!.day.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontSize: 12,
                              color: widget.task.isBefore()
                                  ? Colors.red[300]
                                  : Colors.grey[500],
                            ),
                          )
                        : const Text('No Date'),
                  ],
                ),
              ),
              const Divider(),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Icon(Icons.note_alt_rounded),
                    Text('Note'),
                  ],
                ),
              ),
              const Divider(),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Icon(Icons.attachment),
                    Text('Attachment'),
                  ],
                ),
              ),
              const Spacer(
                flex: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
