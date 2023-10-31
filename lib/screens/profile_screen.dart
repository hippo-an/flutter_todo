import 'package:flutter/material.dart';
import 'package:todo_todo/colors.dart';
import 'package:todo_todo/widgets/base_card.dart';
import 'package:todo_todo/widgets/task_bar_chart.dart';
import 'package:todo_todo/widgets/task_pi_chart.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            width: size.width,
            height: size.height * 0.1,
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 32,
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'username',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'email@gmail.com',
                        style: TextStyle(
                          fontSize: 12,
                          color: kGreyColor,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  splashRadius: 20,
                  onPressed: () {},
                  icon: const Icon(Icons.settings),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: size.width,
            height: 20,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                'Tasks Overview',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: BaseCard(
                  width: size.width,
                  height: size.height * 0.15,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '1',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Completed Tasks',
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: BaseCard(
                  width: size.width,
                  height: size.height * 0.15,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '1',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Pending Tasks',
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          BaseCard(
            width: size.width,
            height: size.height * 0.3,
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Text(
                          'Completion of Daily Tasks',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        Spacer(),
                        Row(
                          children: [
                            Icon(
                              Icons.arrow_left,
                              size: 18,
                            ),
                            Text(
                              '10/30~11/5',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            Icon(
                              Icons.arrow_right,
                              size: 18,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  TaskBarChart(),
                ],
              ),
            ),
          ),
          BaseCard(
            width: size.width,
            height: size.height * 0.08 * 5,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Text(
                        'Tasks in Next 7 Days',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.all(4),
                          child: Row(
                            children: [
                              Icon(
                                Icons.newspaper,
                                size: 18,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: Text(
                                  '${index}',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Text(
                                '11-01',
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          BaseCard(
            width: size.width,
            height: size.height * 0.4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Pending Tasks in Categories',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.arrow_drop_down,
                            size: 18,
                          ),
                          Text(
                            'In 7 Days',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: Row(
                      children: [
                        TaskPiChart(),
                        Expanded(
                          child: Center(
                            child: ListView.builder(
                              itemCount: 5,
                              padding: EdgeInsets.all(2),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Center(
                                  child: Text('• ${index}'),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
