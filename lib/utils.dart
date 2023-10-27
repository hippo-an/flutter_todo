import 'package:flutter/material.dart';
import 'package:uuid/v4.dart';

void showSnackBar(BuildContext context, String? message) {
  if (context.mounted) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
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

String formatDate(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
