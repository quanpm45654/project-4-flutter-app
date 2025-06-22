import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/views/lecturer/widgets/assignment/assignment_create_edit_widget.dart';

class AssignmentCreateEditPage extends StatelessWidget {
  const AssignmentCreateEditPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: AssignmentCreateEditWidget(title: title),
        ),
      ),
    );
  }
}
