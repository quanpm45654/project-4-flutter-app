import 'package:project_4_flutter_app/utils/enums.dart';
import 'package:project_4_flutter_app/utils/functions.dart';

class Assignment {
  int assignment_id;
  String title;
  String description;
  DateTime due_at;
  double max_score;
  AssignmentType assignment_type;
  bool time_bound;
  bool allow_resubmit;
  int class_id;
  String? file_url;

  Assignment(
    this.assignment_id,
    this.title,
    this.description,
    this.due_at,
    this.max_score,
    this.assignment_type,
    this.time_bound,
    this.allow_resubmit,
    this.class_id,
    this.file_url,
  );

  Map<String, dynamic> toJson() => {
    'assignment_id': assignment_id,
    'title': title,
    'description': description,
    'due_at': CustomFormatter.formatDateTime(due_at),
    'max_score': max_score,
    'assignment_type': assignment_type.name.toUpperCase(),
    'time_bound': time_bound ? 1 : 0,
    'allow_resubmit': allow_resubmit ? 1 : 0,
    'class_id': class_id,
    'file_url': file_url,
  };

  factory Assignment.fromJson(Map<String, dynamic> json) {
    var assignment_id = json['assignment_id'] as int;
    var title = json['title'] as String;
    var description = json['description'] as String;
    var due_at = DateTime.parse(json['due_at'] as String);
    var max_score = json['max_score'] is String
        ? double.parse(json['max_score'] as String)
        : json['max_score'] as double;
    var assignment_type = CustomParser.parseAssignmentType(
      json['assignment_type'] as String,
    );
    var time_bound = json['time_bound'] == 1;
    var allow_resubmit = json['allow_resubmit'] == 1;
    var class_id = json['class_id'] as int;
    var file_url = json['file_url'] as String?;

    return Assignment(
      assignment_id,
      title,
      description,
      due_at,
      max_score,
      assignment_type,
      time_bound,
      allow_resubmit,
      class_id,
      file_url,
    );
  }
}
