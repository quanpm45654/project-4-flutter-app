import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/views/lecturer/widgets/assignment/assignment_create_widget.dart';

class AssignmentCreatePage extends StatelessWidget {
  const AssignmentCreatePage({super.key, required this.class_id});

  final int class_id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Create assignment'),
      ),
      body: SafeArea(
        child: AssignmentCreateWidget(class_id: class_id),
      ),
    );
  }
}
