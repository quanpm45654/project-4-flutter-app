import 'package:intl/intl.dart';

String dateFormatter(DateTime dateTime) {
  return DateFormat.yMMMMd().format(dateTime);
}
