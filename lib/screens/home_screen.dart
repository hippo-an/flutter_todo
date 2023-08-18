import 'package:flutter/material.dart';
import 'package:todo_todo/components/main_calendar.dart';
import 'package:todo_todo/models/datas.dart';

class HomeScreen extends StatelessWidget {
  final tasks = dummyTasks;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      drawer: Drawer(
        width: MediaQuery.of(context).size.width / 2,
        child: Column(
          children: [
            const DrawerHeader(
              child: Row(
                children: [
                  Icon(
                    Icons.fastfood_outlined,
                    size: 36,
                  ),
                  SizedBox(width: 14),
                  Text(
                    'Cooking Up',
                  )
                ],
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.restaurant,
                size: 26,
              ),
              title: const Text('Meals!'),
              onTap: () {
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.settings,
                size: 26,
              ),
              title: const Text('Filters'),
              onTap: () {
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Calendar',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            MainCalendar(
              selectedDate: DateTime.now(),
              onDaySelected: (DateTime selectedDay, DateTime focusedDay) => {},
            ),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (ctx, idx) {
                  return tasks[idx];
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
