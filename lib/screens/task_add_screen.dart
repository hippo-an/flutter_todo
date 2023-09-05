import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_todo/models/enums.dart';
import 'package:todo_todo/provider/main_calendar_provider.dart';

class TaskAddScreen extends StatelessWidget {
  const TaskAddScreen({
    super.key,
  });

  Future<bool> _onWillPop(BuildContext context) async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('뒤로 가시겠습니까?'),
            content: const Text('현재 상태가 모두 사라집니다.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('뒤로가기'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('취소'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final mainCalendarProvider = Provider.of<MainCalendarProvider>(context);

    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 30, 12, 12),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      maxLength: 50,
                      decoration: const InputDecoration(
                        label: Text('Task Name'),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().length <= 1 ||
                            value.trim().length > 50) {
                          return '1 ~ 50 글자 사이로 입력해주세요.';
                        }
                        return null;
                      },
                      onSaved: (value) {},
                    ),
                    TextFormField(
                      maxLength: 50,
                      decoration: const InputDecoration(
                        label: Text('Note'),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().length <= 1 ||
                            value.trim().length > 50) {
                          return '1 ~ 50 글자 사이로 입력해주세요.';
                        }
                        return null;
                      },
                      onSaved: (value) {},
                    ),
                    DropdownButtonFormField(
                      value: Urgent.notUrgent,
                      items: [
                        for (final urgent in Urgent.values)
                          DropdownMenuItem<Urgent>(
                            value: urgent,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: urgent.properties.color,
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Text(urgent.properties.koVal),
                              ],
                            ),
                          )
                      ],
                      onSaved: (urgent) {},
                      onChanged: (urgent) {},
                    ),
                    DropdownButtonFormField(
                      value: Importance.notImportance,
                      items: [
                        for (final importance in Importance.values)
                          DropdownMenuItem<Importance>(
                            value: importance,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: importance.properties.color,
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Text(importance.properties.koVal),
                              ],
                            ),
                          )
                      ],
                      onSaved: (importance) {},
                      onChanged: (importance) {},
                    ),
                    DropdownButtonFormField(
                      value: Priority.normal,
                      items: [
                        for (final priority in Priority.values)
                          DropdownMenuItem<Priority>(
                            value: priority,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: priority.properties.color,
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Text(priority.properties.koVal),
                              ],
                            ),
                          )
                      ],
                      onChanged: (priority) {},
                      onSaved: (priority) {},
                    ),
                    DropdownButtonFormField(
                      value: Progression.ready,
                      items: [
                        for (final progression in Progression.values)
                          DropdownMenuItem<Progression>(
                            value: progression,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: progression.properties.color,
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Text(progression.properties.koVal),
                              ],
                            ),
                          )
                      ],
                      onChanged: (progression) {},
                      onSaved: (progression) {},
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today_rounded),
                        labelText: 'Select Date',
                      ),
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: mainCalendarProvider.selectedDate,
                          firstDate: DateTime(1950),
                          lastDate: DateTime(2999),
                        );

                        if (pickedDate != null) {
                          print(pickedDate);
                        }
                      },
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            _formKey.currentState!.reset();
                          },
                          child: const Text('Reset'),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text(
                            'Add Task',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
