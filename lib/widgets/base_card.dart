import 'package:flutter/material.dart';
import 'package:todo_todo/colors.dart';

class BaseCard extends StatelessWidget {
  const BaseCard({
    super.key,
    this.width = 50.0,
    this.height = 50.0,
    this.color = kGreyColor,
    this.child,
  });

  final double width;
  final double height;
  final Color color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: child,
      ),
    );
  }
}
