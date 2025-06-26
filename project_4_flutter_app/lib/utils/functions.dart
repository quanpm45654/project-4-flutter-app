import 'package:intl/intl.dart';
import 'package:project_4_flutter_app/utils/enums.dart';

class CustomFormatter {
  static String formatDateTime(DateTime dateTime) {
    return DateFormat.yMMMMd().format(dateTime);
  }

  static String formatDateTime2(DateTime dateTime) {
    return DateFormat('MMMM dd, yyyy, hh:mm a').format(dateTime);
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
