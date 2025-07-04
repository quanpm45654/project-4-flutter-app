import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/teacher/models/submission.dart';
import 'package:project_4_flutter_app/teacher/widgets/submission/submission_widget.dart';

class SubmissionPage extends StatelessWidget {
  const SubmissionPage({super.key, required this.submission});

  final Submission submission;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submission'),
      ),
      body: SafeArea(
        child: SubmissionWidget(submission: submission),
      ),
    );
  }
}
