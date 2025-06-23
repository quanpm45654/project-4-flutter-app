import 'package:project_4_flutter_app/utils/enums.dart';
import 'package:project_4_flutter_app/utils/functions.dart';

class Assignment {
  final int assignment_id;
  final String title;
  final String description;
  final DateTime due_at;
  final double max_score;
  final AssignmentType assignment_type;
  final int time_bound;
  final int allow_resubmit;
  final int class_id;

  Assignment({
    required this.assignment_id,
    required this.title,
    required this.description,
    required this.due_at,
    required this.max_score,
    required this.assignment_type,
    required this.time_bound,
    required this.allow_resubmit,
    required this.class_id,
  });

  Map<String, dynamic> toJson() => {
    'assignment_id': assignment_id,
    'title': title,
    'description': description,
    'due_at': due_at,
    'max_score': max_score,
    'assignment_type': assignment_type,
    'time_bound': time_bound,
    'allow_resubmit': allow_resubmit,
    'class_id': class_id,
  };

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      assignment_id: int.parse(json['assignment_id'] as String),
      title: json['title'] as String,
      description: json['description'] as String,
      due_at: DateTime.parse(json['due_at'] as String),
      max_score: double.parse(json['max_score'] as String),
      assignment_type: CustomParser.parseAssignmentType(['max_score'] as String),
      time_bound: int.parse(json['time_bound'] as String),
      allow_resubmit: int.parse(json['allow_resubmit'] as String),
      class_id: int.parse(json['class_id'] as String),
    );
  }
}
