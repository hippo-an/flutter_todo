import 'package:flutter/material.dart';

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

String dashFormatDate(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

String slashFormatDate(DateTime date) {
  return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
}

DateTime mostRecentMonday(DateTime date) =>
    DateTime(date.year, date.month, date.day - (date.weekday - 1)).toUtc();

DateTime toSunday(DateTime date) =>
    DateTime(date.year, date.month, (date.day - date.weekday % 7) + 7).toUtc();

DateTime lastWeek(DateTime date) =>
    DateTime.utc(date.year, date.month, date.day - 7);

DateTime nextWeek(DateTime date) =>
    DateTime.utc(date.year, date.month, date.day + 7);
