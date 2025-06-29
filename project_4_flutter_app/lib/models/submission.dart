import 'package:project_4_flutter_app/utils/functions.dart';

class Submission {
  final num submission_id;
  final num assignment_id;
  final num student_id;
  final String? student_name;
  final num attempt;
  final DateTime submitted_at;
  final String? note;
  final String file_url;
  final num? score;
  final String? feedback_text;
  final String? feedback_file_url;
  final num? graded_by;
  final String? graded_at;

  Submission({
    required this.submission_id,
    required this.assignment_id,
    required this.student_id,
    this.student_name,
    required this.attempt,
    required this.submitted_at,
    this.note,
    required this.file_url,
    this.score,
    this.feedback_text,
    this.feedback_file_url,
    this.graded_by,
    this.graded_at,
  });

  Map<String, dynamic> toJson() => {
    'submission_id': submission_id,
    'assignment_id': assignment_id,
    'student_id': student_id,
    'attempt': attempt,
    'submitted_at': CustomFormatter.formatDateTime(submitted_at),
    'note': note,
    'file_url': file_url,
    'score': score,
    'feedback_text': feedback_text,
    'feedback_file_url': feedback_file_url,
    'graded_by': graded_by,
    'graded_at': graded_at,
  };

  factory Submission.fromJson(Map<String, dynamic> json) {
    return Submission(
      submission_id: json['submission_id'] as num,
      assignment_id: json['assignment_id'] as num,
      student_id: json['student_id'] as num,
      student_name: json['full_name'] as String?,
      attempt: json['attempt'] as num,
      submitted_at: DateTime.parse(json['submitted_at'] as String),
      note: json['note'] as String?,
      file_url: json['file_url'] as String,
      score: json['score'] is String ? num.parse(json['score'] as String) : json['score'] as num,
      feedback_text: json['feedback_text'] as String?,
      feedback_file_url: json['feedback_file_url'] as String?,
      graded_by: json['graded_by'] as num?,
      graded_at: json['graded_at'] as String?,
    );
  }
}
