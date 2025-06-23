import 'package:intl/intl.dart';
import 'package:project_4_flutter_app/utils/enums.dart';

class CustomFormatter {
  static String formatDateTime(DateTime dateTime) {
    return DateFormat.yMMMMd().format(dateTime);
  }
}

class CustomParser {
  static AssignmentType parseAssignmentType(String value) {
    for (final assignmentType in AssignmentType.values) {
      if (value == assignmentType.toString()) {
        return assignmentType;
      }
    }
    return AssignmentType.values.elementAt(0);
  }

  static Role parseRole(String value) {
    for (final role in Role.values) {
      if (value == role.toString()) {
        return role;
      }
    }
    return Role.values.elementAt(2);
  }
}
