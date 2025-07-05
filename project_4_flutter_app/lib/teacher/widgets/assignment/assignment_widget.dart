import 'package:flutter/material.dart';

import '../../models/assignment.dart';
import '../../utils/functions.dart';

class AssignmentWidget extends StatelessWidget {
  const AssignmentWidget({super.key, required this.assignment});

  final Assignment assignment;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const CircleAvatar(
              child: Icon(Icons.assignment_outlined),
            ),
            title: Text(
              assignment.title ?? '',
              style: const TextStyle(fontSize: 18.0),
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            'Due ${CustomFormatter.formatDateTime(assignment.due_date)}',
            style: DateTime.now().isAfter(assignment.due_date)
                ? TextStyle(color: Colors.red.shade900)
                : const TextStyle(),
          ),
          const Divider(),
          Text(
            'Description',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Text(assignment.description ?? ''),
          const SizedBox(height: 8.0),
          Text(
            'Attachment',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          SelectableText(assignment.attached_file ?? ''),
          const SizedBox(height: 8.0),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: assignment.allow_resubmit
                ? Icon(
                    Icons.check_rounded,
                    color: Colors.green.shade900,
                    size: 32,
                  )
                : Icon(
                    Icons.close_rounded,
                    color: Colors.red.shade900,
                    size: 32,
                  ),
            title: const Text('Allow resubmit'),
          ),
        ],
      ),
    );
  }
}
