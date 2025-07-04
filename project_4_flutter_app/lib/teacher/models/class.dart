class Class {
  int id;
  String? class_name;
  int teacher_id;
  String? code;

  Class(
    this.id,
    this.class_name,
    this.teacher_id,
    this.code,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'class_name': class_name,
    'teacher_id': teacher_id,
    'code': code,
  };

  factory Class.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int;
    final class_name = json['class_name'] as String?;
    final teacher_id = json['teacher_id'] as int;
    final code = json['code'] as String?;

    return Class(id, class_name, teacher_id, code);
  }
}
