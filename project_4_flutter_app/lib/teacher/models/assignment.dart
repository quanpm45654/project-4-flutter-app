import 'package:project_4_flutter_app/teacher/utils/functions.dart';

class Assignment {
  int id;
  int class_id;
  String? title;
  String? description;
  String? attached_file;
  DateTime due_date;
  bool allow_resubmit;

  Assignment(
    this.id,
    this.class_id,
    this.title,
    this.description,
    this.attached_file,
    this.due_date,
    this.allow_resubmit,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'class_id': class_id,
    'title': title,
    'description': description,
    'attached_file': attached_file,
    'due_date': CustomFormatter.formatDateTime(due_date),
    'allow_resubmit': allow_resubmit ? 1 : 0,
  };

  factory Assignment.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int;
    final class_id = json['class_id'] as int;
    final title = json['title'] as String?;
    final description = json['description'] as String?;
    final attached_file = json['attached_file'] as String?;
    final due_date = DateTime.parse(json['due_date'] as String);
    final allow_resubmit = json['allow_resubmit'] == 1;

    return Assignment(
      id,
      class_id,
      title,
      description,
      attached_file,
      due_date,
      allow_resubmit,
    );
  }
}
