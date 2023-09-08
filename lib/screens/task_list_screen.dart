import 'package:flutter/material.dart';
import 'package:todo_todo/components/custom_floating_action_button.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  static const routeName = 'tasks';
  static final categories = <String>['All', 'Work', 'Personal', 'Wishlist'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const CustomFloatingActionButton(),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.04,
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: categories.length,
                padding: const EdgeInsets.all(4),
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text(categories[index]),
                    ),
                  );
                },
              ),
            ),
            Center(
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.more_vert),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
