import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/models/submission.dart';
import 'package:project_4_flutter_app/utils/functions.dart';

class SubmissionWidget extends StatelessWidget {
  const SubmissionWidget({super.key, required this.submission});

  final Submission submission;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${submission.student_name}',
          style: const TextStyle(fontSize: 24.0),
        ),
        const Text(
          'Note',
          style: TextStyle(fontSize: 20.0),
        ),
        Text(
          '${submission.note}',
          style: const TextStyle(fontSize: 16.0),
        ),
        const Text(
          'Submitted at',
          style: TextStyle(fontSize: 20.0),
        ),
        Text(
          CustomFormatter.formatDateTime(submission.submitted_at),
          style: const TextStyle(fontSize: 16.0),
        ),
        const Text(
          'Score',
          style: TextStyle(fontSize: 20.0),
        ),
        Text(
          '${submission.score}',
          style: const TextStyle(fontSize: 16.0),
        ),
        const Text(
          'Attachment',
          style: TextStyle(fontSize: 20.0),
        ),
        Text(
          submission.file_url,
          style: const TextStyle(fontSize: 16.0),
        ),
        const Text(
          'Feedback',
          style: TextStyle(fontSize: 20.0),
        ),
        Text(
          submission.feedback_text ?? '',
          style: const TextStyle(fontSize: 16.0),
        ),
        Text(
          submission.feedback_file_url ?? '',
          style: const TextStyle(fontSize: 16.0),
        ),
        const Text(
          'Comment',
          style: TextStyle(fontSize: 20.0),
        ),
      ],
    );
  }
}
