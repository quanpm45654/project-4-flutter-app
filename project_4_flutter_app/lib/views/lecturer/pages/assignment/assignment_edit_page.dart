import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/models/assignment.dart';
import 'package:project_4_flutter_app/views/lecturer/widgets/assignment/assignment_edit_widget.dart';

class AssignmentEditPage extends StatelessWidget {
  const AssignmentEditPage({super.key, required this.assignment});

  final Assignment assignment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Edit assignment'),
      ),
      body: SafeArea(
        child: AssignmentEditWidget(assignment: assignment),
      ),
    );
  }
}
