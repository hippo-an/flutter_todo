import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:todo_todo/widgets/task_bottom_sheet.dart';

class AnimatedFloatingButton extends StatelessWidget {
  const AnimatedFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AvatarGlow(
      glowColor: Theme.of(context).colorScheme.primary,
      endRadius: 40,
      duration: const Duration(milliseconds: 2000),
      repeat: true,
      showTwoGlows: true,
      repeatPauseDuration: const Duration(milliseconds: 150),
      child: Material(     // Replace this child with your own
        elevation: 8,
        shape: const CircleBorder(),
        child: GestureDetector(
          onTap: () {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) => const TaskBottomSheet(),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(4),
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ),
    );
  }
}
