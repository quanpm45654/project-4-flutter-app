class Submission {
  int? submission_id;
  int? assignment_id;
  int? feedback_id;
  String? student_name;
  String? note;
  DateTime? submitted_at;
  String? file_path;
  double? score;
  String? comment;
  String? submit_status;
  String? grade_status;

  Submission(
    this.submission_id,
    this.assignment_id,
    this.feedback_id,
    this.student_name,
    this.note,
    this.submitted_at,
    this.file_path,
    this.score,
    this.comment,
    this.submit_status,
    this.grade_status,
  );

  factory Submission.fromJson(Map<String, dynamic> json) {
    final submission_id = json['submission_id'] as int?;
    final assignment_id = json['assignment_id'] as int?;
    final feedback_id = json['feedback_id'] as int?;
    final student_name = json['student_name'] as String?;
    final note = json['note'] as String?;
    final submitted_at = json['submitted_at'] != null
        ? DateTime.parse(json['submitted_at'] as String)
        : null;
    final file_path = json['file_path'] as String?;
    final score = json['score'] != null
        ? json['score'] is String
              ? double.parse(json['score'] as String)
              : json['score'] as double
        : null;
    final comment = json['comment'] as String?;
    final submit_status = json['submit_status'] as String?;
    final grade_status = json['grade_status'] as String?;

    return Submission(
      submission_id,
      assignment_id,
      feedback_id,
      student_name,
      note,
      submitted_at,
      file_path,
      score,
      comment,
      submit_status,
      grade_status,
    );
  }
}
