import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_4_flutter_app/utils/enums.dart';

class CustomFormatter {
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }
}

class CustomParser {
  static AssignmentType parseAssignmentType(String string) {
    for (final assignmentType in AssignmentType.values) {
      if (string == assignmentType.toString()) {
        return assignmentType;
      }
    }
    return AssignmentType.values.elementAt(0);
  }

  static Role parseRole(String string) {
    for (final role in Role.values) {
      if (string == role.toString()) {
        return role;
      }
    }
    return Role.values.elementAt(2);
  }
}

Future<DateTime?> showDateTimePicker({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  initialDate ??= DateTime.now();
  firstDate ??= initialDate.subtract(const Duration(days: 365 * 100));
  lastDate ??= firstDate.add(const Duration(days: 365 * 200));

  final DateTime? selectedDate = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
  );

  if (selectedDate == null) return null;

  if (!context.mounted) return selectedDate;

  final TimeOfDay? selectedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(initialDate),
  );

  return selectedTime == null
      ? selectedDate
      : DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
}
