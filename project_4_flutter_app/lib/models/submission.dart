class Submission {
  final int submission_id;
  final int assignment_id;
  final int student_id;
  final String? student_name;
  final int attempt;
  final DateTime submitted_at;
  final String? note;
  final String file_url;
  final String? score;
  final String? feedback_text;
  final String? feedback_file_url;
  final int? graded_by;
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
    'submitted_at': submitted_at,
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
      submission_id: json['submission_id'] as int,
      assignment_id: json['assignment_id'] as int,
      student_id: json['student_id'] as int,
      student_name: json['full_name'] as String?,
      attempt: json['attempt'] as int,
      submitted_at: DateTime.parse(json['submitted_at'] as String),
      note: json['note'] as String?,
      file_url: json['file_url'] as String,
      score: json['score'] as String?,
      feedback_text: json['feedback_text'] as String?,
      feedback_file_url: json['feedback_file_url'] as String?,
      graded_by: json['graded_by'] as int?,
      graded_at: json['graded_at'] as String?,
    );
  }
}
