import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/models/assignment.dart';
import 'package:project_4_flutter_app/utils/functions.dart';

class AssignmentWidget extends StatelessWidget {
  const AssignmentWidget({super.key, required this.assignment});

  final Assignment assignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: const Icon(Icons.assignment_rounded),
            ),
            title: Text(
              assignment.title,
              style: const TextStyle(fontSize: 24.0),
            ),
          ),
          const SizedBox(),
          Text(
            'Due ${CustomFormatter.formatDateTime(assignment.due_at)}',
            style: DateTime.now().isAfter(assignment.due_at)
                ? TextStyle(color: Theme.of(context).colorScheme.error)
                : const TextStyle(),
          ),
          const SizedBox(),
          Text('${assignment.max_score} point'),
          const SizedBox(),
          Text(
            'Description',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Text('${assignment.description}'),
          const SizedBox(),
          Text(
            'Attachment',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Text(assignment.file_url ?? ''),
          const SizedBox(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: assignment.assignment_type.name == 'individual'
                ? const Icon(
                    Icons.person_rounded,
                    size: 32,
                  )
                : const Icon(
                    Icons.groups_rounded,
                    size: 32,
                  ),
            title: Text(assignment.assignment_type.name.toUpperCase()),
          ),
          const SizedBox(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: assignment.time_bound
                ? const Icon(
                    Icons.check_box,
                    color: Colors.green,
                    size: 32,
                  )
                : const Icon(
                    Icons.cancel_rounded,
                    color: Colors.red,
                    size: 32,
                  ),
            title: const Text('Time bound'),
          ),
          const SizedBox(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: assignment.allow_resubmit
                ? const Icon(
                    Icons.check_box,
                    color: Colors.green,
                    size: 32,
                  )
                : const Icon(
                    Icons.cancel_rounded,
                    color: Colors.red,
                    size: 32,
                  ),
            title: const Text('Allow resubmit'),
          ),
        ],
      ),
    );
  }
}
