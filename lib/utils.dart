import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String? message) {
  if (context.mounted) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(milliseconds: 2000),
          content: Text(message ?? 'Error occurred'),
        ),
      );
  }
}
