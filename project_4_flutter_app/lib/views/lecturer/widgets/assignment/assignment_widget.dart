import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/models/assignment.dart';
import 'package:project_4_flutter_app/utils/functions.dart';

class AssignmentWidget extends StatelessWidget {
  const AssignmentWidget({super.key, required this.assignment});

  final Assignment assignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 16.0,
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: const Icon(Icons.assignment_rounded),
            ),
            Text(
              assignment.title,
              style: const TextStyle(fontSize: 24.0),
            ),
          ],
        ),
        const Text(
          'Score',
          style: TextStyle(fontSize: 20.0),
        ),
        Text(
          '${assignment.max_score}',
          style: const TextStyle(fontSize: 16.0),
        ),
        const Text(
          'Due at',
          style: TextStyle(fontSize: 20.0),
        ),
        Text(
          CustomFormatter.formatDateTime(assignment.due_at),
          style: DateTime.now().isAfter(assignment.due_at)
              ? TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 16.0)
              : const TextStyle(fontSize: 16.0),
        ),
        const Text(
          'Description',
          style: TextStyle(fontSize: 20.0),
        ),
        Text(
          '${assignment.description}',
          style: const TextStyle(fontSize: 16.0),
        ),
        const Text(
          'Attachment',
          style: TextStyle(fontSize: 20.0),
        ),
        Text(
          assignment.file_url ?? '',
          style: const TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }
}
