import 'package:project_4_flutter_app/utils/enums.dart';

class Assignment {
  final int id;
  final String title;
  final String description;
  final DateTime due_at;
  final double max_score;
  final AssignmentType assignment_type;
  final int time_bound;
  final int allow_resubmit;
  final int class_id;

  Assignment({
    required this.id,
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
    'id': id,
    'title': title,
    'description': description,
    'due_at': due_at,
    'max_score': max_score,
    'assignment_type': assignment_type,
    'time_bound': time_bound,
    'allow_resubmit': allow_resubmit,
    'classroom_id': class_id,
  };

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      due_at: json['due_at'] as DateTime,
      max_score: json['max_score'] as double,
      assignment_type: json['assignment_type'] as AssignmentType,
      time_bound: json['time_bound'] as int,
      allow_resubmit: json['allow_resubmit'] as int,
      class_id: json['classroom_id'] as int,
    );
  }
}
