import 'package:flutter/material.dart';
import 'package:uuid/v4.dart';

void showSnackBar(BuildContext context, String? message) {
  if (context.mounted) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          backgroundColor:
              Theme.of(context).colorScheme.primary.withOpacity(0.8),
          showCloseIcon: true,
          duration: const Duration(milliseconds: 2000),
          content: Text(message ?? 'Error occurred'),
        ),
      );
  }
}


const uuid = UuidV4();
