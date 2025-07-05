class Teacher {
  int id;
  String? full_name;
  String? email;

  Teacher(
    this.id,
    this.full_name,
    this.email,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'full_name': full_name,
    'email': email,
  };

  factory Teacher.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int;
    final full_name = json['full_name'] as String?;
    final email = json['email'] as String?;

    return Teacher(id, full_name, email);
  }
}
