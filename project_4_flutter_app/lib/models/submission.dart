import 'package:project_4_flutter_app/utils/functions.dart';

class Submission {
  int submission_id = 0;
  int assignment_id = 0;
  int student_id = 0;
  String? student_name;
  int attempt = 0;
  DateTime submitted_at = DateTime.now();
  String? note;
  String file_url = '';
  double? score;
  String? feedback_text;
  String? feedback_file_url;
  int? graded_by;
  String? graded_at;

  Submission(
    this.submission_id,
    this.assignment_id,
    this.student_id,
    this.student_name,
    this.attempt,
    this.submitted_at,
    this.note,
    this.file_url,
    this.score,
    this.feedback_text,
    this.feedback_file_url,
    this.graded_by,
    this.graded_at,
  );

  Submission.empty();

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
    var submission_id = json['submission_id'] as int;
    var assignment_id = json['assignment_id'] as int;
    var student_id = json['student_id'] as int;
    var student_name = json['full_name'] as String?;
    var attempt = json['attempt'] as int;
    var submitted_at = DateTime.parse(json['submitted_at'] as String);
    var note = json['note'] as String?;
    var file_url = json['file_url'] as String;
    var score = json['score'] is String
        ? double.parse(json['score'] as String)
        : json['score'] as double;
    var feedback_text = json['feedback_text'] as String?;
    var feedback_file_url = json['feedback_file_url'] as String?;
    var graded_by = json['graded_by'] as int?;
    var graded_at = json['graded_at'] as String?;

    return Submission(
      submission_id,
      assignment_id,
      student_id,
      student_name,
      attempt,
      submitted_at,
      note,
      file_url,
      score,
      feedback_text,
      feedback_file_url,
      graded_by,
      graded_at,
    );
  }
}
