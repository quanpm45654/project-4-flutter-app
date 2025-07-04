class Student {
  int id;
  String? full_name;
  String? email;
  int enrollment_id;

  Student(
    this.id,
    this.full_name,
    this.email,
    this.enrollment_id,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'full_name': full_name,
    'email': email,
  };

  factory Student.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int;
    final full_name = json['full_name'] as String?;
    final email = json['email'] as String?;
    final enrollment_id = json['enrollment_id'] as int;

    return Student(id, full_name, email, enrollment_id);
  }
}
