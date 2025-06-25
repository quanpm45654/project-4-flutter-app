import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/models/assignment.dart';
import 'package:project_4_flutter_app/utils/constants.dart';
import 'package:project_4_flutter_app/views/lecturer/widgets/assignment/assignment_widget.dart';
import 'package:project_4_flutter_app/views/lecturer/widgets/lecturer_navigation_bar.dart';

class AssignmentPage extends StatelessWidget {
  const AssignmentPage({super.key, required this.assignment});

  final Assignment assignment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Assignment detail',
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(
            CustomSize.medium,
          ),
          child: AssignmentWidget(
            assignment: assignment,
          ),
        ),
      ),
      bottomNavigationBar: const LecturerNavigationBar(),
    );
  }
}
