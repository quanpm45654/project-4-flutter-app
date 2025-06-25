class Class {
  final int class_id;
  final String class_code;
  final String class_name;
  final String description;
  final String semester;
  final int lecturer_id;

  Class({
    required this.class_id,
    required this.class_code,
    required this.class_name,
    required this.description,
    required this.semester,
    required this.lecturer_id,
  });

  Map<String, dynamic> toJson() => {
    'class_id': class_id,
    'class_code': class_code,
    'class_name': class_name,
    'description': description,
    'semester': semester,
    'lecturer_id': lecturer_id,
  };

  factory Class.fromJson(Map<String, dynamic> json) {
    return Class(
      class_id: json['class_id'] as int,
      class_code: json['class_code'] as String,
      class_name: json['class_name'] as String,
      description: json['description'] as String,
      semester: json['semester'] as String,
      lecturer_id: json['lecturer_id'] as int,
    );
  }
}
