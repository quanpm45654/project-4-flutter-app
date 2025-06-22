class Class {
  final int id;
  final String code;
  final String name;
  final String description;
  final String semester;
  final int lecturer_id;

  Class({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.semester,
    required this.lecturer_id,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'code': code,
    'name': name,
    'description': description,
    'semester': semester,
    'lecturer_id': lecturer_id,
  };

  factory Class.fromJson(Map<String, dynamic> json) {
    return Class(
      id: json['id'] as int,
      code: json['code'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      semester: json['semester'] as String,
      lecturer_id: json['lecturer_id'] as int,
    );
  }
}
