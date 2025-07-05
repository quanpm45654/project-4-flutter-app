import 'package:flutter/material.dart';

import '../../models/submission.dart';
import '../../widgets/submission/submission_widget.dart';

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
