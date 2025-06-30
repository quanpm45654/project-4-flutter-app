class Class {
  int class_id;
  String class_code;
  String class_name;
  String description;
  String semester;
  int lecturer_id;

  Class(
    this.class_id,
    this.class_code,
    this.class_name,
    this.description,
    this.semester,
    this.lecturer_id,
  );

  Map<String, dynamic> toJson() => {
    'class_id': class_id,
    'class_code': class_code,
    'class_name': class_name,
    'description': description,
    'semester': semester,
    'lecturer_id': lecturer_id,
  };

  factory Class.fromJson(Map<String, dynamic> json) {
    var class_id = json['class_id'] as int;
    var class_code = json['class_code'] as String;
    var class_name = json['class_name'] as String;
    var description = json['description'] as String;
    var semester = json['semester'] as String;
    var lecturer_id = json['lecturer_id'] as int;

    return Class(
      class_id,
      class_code,
      class_name,
      description,
      semester,
      lecturer_id,
    );
  }
}
