import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/components/category_select_dialog.dart';
import 'package:todo_todo/models/category_model.dart';
import 'package:todo_todo/provider/category_list_provider.dart';
import 'package:todo_todo/provider/selected_category_provider.dart';

class TaskBottomSheet extends StatefulWidget {
  const TaskBottomSheet({
    super.key,
    required this.selectedCategory,
  });

  final CategoryModel? selectedCategory;

  @override
  State<TaskBottomSheet> createState() => _TaskBottomSheetState();
}

class _TaskBottomSheetState extends State<TaskBottomSheet> {
  CategoryModel? _category;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _category = widget.selectedCategory;
  }

  void _dateSelectDialog() async {
    final now = _selectedDate ?? DateTime.now();
    final dateTime = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 10),
    );

    setState(() {
      _selectedDate = dateTime;
    });
  }

  void _categorySelectDialog() async {
    final (id, name) = await showDialog(
      context: context,
      builder: (context) {
        return const CategorySelectDialog();
      },
    );

    if (id == null && name == null) {
      setState(() {
        _category = null;
      });
    } else {
      setState(() {
        _category = Provider.of<CategoryListProvider>(context, listen: false)
            .findCategory(id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: const Duration(milliseconds: 100),
          curve: Curves.decelerate,
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextField(
                      autofocus: true,
                      maxLines: 1,
                      maxLength: 50,
                      expands: false,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Input new task here',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        floatingLabelAlignment: FloatingLabelAlignment.start,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: const BorderSide(
                            color: Colors.lightBlueAccent,
                          ),
                        ),
                        labelStyle: const TextStyle(fontSize: 12),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            _category == null
                                ? IconButton(
                                    onPressed: _categorySelectDialog,
                                    icon: const Icon(Icons.category_outlined))
                                : Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.035,
                                      child: OutlinedButton(
                                        onPressed: _categorySelectDialog,
                                        child: Text(
                                          _category == null
                                              ? 'No Category'
                                              : _category!.name,
                                          style: const TextStyle(
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                            _selectedDate != null
                                ? Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.035,
                                      child: OverflowBar(
                                        children: [
                                          OutlinedButton(
                                            onPressed: _dateSelectDialog,
                                            child: Text(
                                              '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}',
                                              style: const TextStyle(
                                                fontSize: 11,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : IconButton(
                                    onPressed: _dateSelectDialog,
                                    icon: const Icon(
                                      Icons.calendar_month_sharp,
                                      size: 22,
                                    ),
                                  ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.alt_route,
                                size: 22,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.send_sharp,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
