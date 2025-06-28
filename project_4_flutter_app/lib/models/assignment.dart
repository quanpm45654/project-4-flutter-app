import 'package:project_4_flutter_app/utils/enums.dart';
import 'package:project_4_flutter_app/utils/functions.dart';

class Assignment {
  final num assignment_id;
  final String title;
  final String? description;
  final DateTime due_at;
  final num max_score;
  final AssignmentType assignment_type;
  final bool time_bound;
  final bool allow_resubmit;
  final num class_id;
  final String? file_url;

  Assignment({
    required this.assignment_id,
    required this.title,
    this.description,
    required this.due_at,
    required this.max_score,
    required this.assignment_type,
    required this.time_bound,
    required this.allow_resubmit,
    required this.class_id,
    this.file_url,
  });

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
    return Assignment(
      assignment_id: json['assignment_id'] as num,
      title: json['title'] as String,
      description: json['description'] as String?,
      due_at: DateTime.parse(json['due_at'] as String),
      max_score: json['max_score'] is String
          ? num.parse(json['max_score'] as String)
          : json['max_score'] as num,
      assignment_type: CustomParser.parseAssignmentType(json['assignment_type'] as String),
      time_bound: json['time_bound'] == 1,
      allow_resubmit: json['allow_resubmit'] == 1,
      class_id: json['class_id'] as num,
      file_url: json['file_url'] as String?,
    );
  }
}
