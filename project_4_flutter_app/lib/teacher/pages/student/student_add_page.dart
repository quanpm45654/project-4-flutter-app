import 'package:flutter/material.dart';

import '../../widgets/student/student_add_widget.dart';

class StudentAddPage extends StatelessWidget {
  const StudentAddPage({super.key, required this.class_id});

  final int class_id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Add student'),
      ),
      body: SafeArea(
        child: StudentAddWidget(class_id: class_id),
      ),
    );
  }
}
