import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedArrowButton extends StatefulWidget {
  const AnimatedArrowButton({
    super.key,
    required this.onTap,
    required this.open,
  });

  final void Function() onTap;
  final bool open;

  @override
  State<AnimatedArrowButton> createState() => _AnimatedArrowButtonState();
}

class _AnimatedArrowButtonState extends State<AnimatedArrowButton>
    with TickerProviderStateMixin {
  late final Animation<double> _arrowAnimation;
  late final AnimationController _arrowAnimationController;

  @override
  void initState() {
    _arrowAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _arrowAnimation =
        Tween(begin: 0.0, end: pi).animate(_arrowAnimationController);

    super.initState();
  }

  @override
  void dispose() {
    _arrowAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        if (_arrowAnimationController.isCompleted) {
          await _arrowAnimationController.reverse();
        } else {
          await _arrowAnimationController.forward();
        }

        await Future.delayed(
          const Duration(milliseconds: 250),
        );

        widget.onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastLinearToSlowEaseIn,
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 30,
              offset: const Offset(5, 5),
            ),
          ],
        ),
        child: AnimatedBuilder(
          animation: _arrowAnimationController,
          builder: (context, child) => Transform.rotate(
            angle: _arrowAnimation.value,
            child: const Icon(Icons.arrow_drop_down),
          ),
        ),
      ),
    );
  }
}
