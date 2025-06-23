class Submission {
  final int submission_id;
  final int assignment_id;
  final int student_id;
  final int attempt;
  final DateTime submitted_at;
  final String note;
  final String file_url;
  final double score;
  final String feedback_text;
  final String feedback_file_url;
  final int graded_by;
  final DateTime graded_at;

  Submission({
    required this.submission_id,
    required this.assignment_id,
    required this.student_id,
    required this.attempt,
    required this.submitted_at,
    required this.note,
    required this.file_url,
    required this.score,
    required this.feedback_text,
    required this.feedback_file_url,
    required this.graded_by,
    required this.graded_at,
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
      submission_id: int.parse(json['submission_id'] as String),
      assignment_id: int.parse(json['submission_id'] as String),
      student_id: int.parse(json['submission_id'] as String),
      attempt: int.parse(json['submission_id'] as String),
      submitted_at: DateTime.parse(json['submitted_at'] as String),
      note: json['note'] as String,
      file_url: json['file_url'] as String,
      score: double.parse(json['submission_id'] as String),
      feedback_text: json['feedback_text'] as String,
      feedback_file_url: json['feedback_file_url'] as String,
      graded_by: int.parse(json['submission_id'] as String),
      graded_at: DateTime.parse(json['graded_at'] as String),
    );
  }
}
