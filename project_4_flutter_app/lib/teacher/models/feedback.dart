class Feedback {
  int id;
  int submission_id;
  double score;
  String? comment;

  Feedback(
    this.id,
    this.submission_id,
    this.score,
    this.comment,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'submission_id': submission_id,
    'score': score,
    'comment': comment,
  };

  factory Feedback.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int;
    final submission_id = json['submission_id'] as int;
    final score = json['score'] is String
        ? double.parse(json['score'] as String)
        : json['score'] as double;
    final comment = json['comment'] as String?;

    return Feedback(id, submission_id, score, comment);
  }
}
