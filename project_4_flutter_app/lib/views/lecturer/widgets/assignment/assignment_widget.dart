import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/models/assignment.dart';
import 'package:project_4_flutter_app/utils/functions.dart';

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
              assignment.title,
              style: const TextStyle(fontSize: 20.0),
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            'Due ${CustomFormatter.formatDateTime(assignment.due_at)}',
            style: DateTime.now().isAfter(assignment.due_at)
                ? TextStyle(color: Colors.red.shade900)
                : const TextStyle(),
          ),
          const SizedBox(height: 8.0),
          Text('${assignment.max_score} point'),
          const SizedBox(height: 8.0),
          Text(
            'Description',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Text(assignment.description),
          const SizedBox(height: 8.0),

          Text(
            'Attachment',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          SelectableText(assignment.file_url ?? ''),
          const SizedBox(height: 8.0),
          const Divider(),
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
            title: const Text('Time bound'),
          ),
          const SizedBox(),
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
