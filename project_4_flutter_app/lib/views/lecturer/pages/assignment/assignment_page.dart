import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/models/assignment.dart';
import 'package:project_4_flutter_app/views/lecturer/widgets/assignment/assignment_widget.dart';

class AssignmentPage extends StatelessWidget {
  const AssignmentPage({super.key, required this.assignment});

  final Assignment assignment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignment detail'),
      ),
      body: SafeArea(
        child: AssignmentWidget(assignment: assignment),
      ),
    );
  }
}
