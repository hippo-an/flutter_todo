import 'package:flutter/material.dart';
import 'package:todo_todo/colors.dart';

class AnimatedCheckBox extends StatefulWidget {
  const AnimatedCheckBox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final Future<void> Function(bool value) onChanged;

  @override
  State<AnimatedCheckBox> createState() => _AnimatedCheckBoxState();
}

class _AnimatedCheckBoxState extends State<AnimatedCheckBox>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation =
        Tween(begin: widget.value ? 1.0 : 0.0, end: widget.value ? 0.0 : 1.0)
            .animate(_controller);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onTap() async {
    if (_controller.isCompleted) {
      await _controller.reverse();
    } else {
      await _controller.forward();
    }

    await Future.delayed(
      const Duration(milliseconds: 200),
    );

    await widget.onChanged(!widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          height: 26,
          width: 26,
          decoration: const BoxDecoration(
            color: Colors.transparent,
            border: Border.fromBorderSide(
              BorderSide(color: kGreyColor, width: 2),
            ),
            shape: BoxShape.circle,
          ),
          child: ScaleTransition(
            scale: _animation,
            child: const Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.check_circle,
                size: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
