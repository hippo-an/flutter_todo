import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

class AnimatedFloatingButton extends StatelessWidget {
  const AnimatedFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AvatarGlow(
      glowColor: Theme.of(context).colorScheme.primary,
      endRadius: 40.0,
      duration: const Duration(milliseconds: 2000),
      repeat: true,
      showTwoGlows: true,
      repeatPauseDuration: const Duration(milliseconds: 100),
      child: Material(     // Replace this child with your own
        elevation: 8,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: () {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) => Container(),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(4),
            height: 50,
            width: 50,
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
