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
        Text(
          assignment.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(
          'Score: ${assignment.max_score}',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          'Due ${CustomFormatter.formatDateTime2(
            assignment.due_at,
          )}',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          assignment.description,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
