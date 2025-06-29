import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/repositories/submission_repository.dart';
import 'package:project_4_flutter_app/utils/functions.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/submission/submission_page.dart';
import 'package:provider/provider.dart';

class SubmissionListWidget extends StatefulWidget {
  const SubmissionListWidget({super.key, required this.assignment_id});

  final num assignment_id;

  @override
  State<SubmissionListWidget> createState() => _SubmissionListWidgetState();
}

class _SubmissionListWidgetState extends State<SubmissionListWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SubmissionRepository>(
        context,
        listen: false,
      ).fetchSubmissionList(assignment_id: widget.assignment_id);
      Provider.of<SubmissionRepository>(
        context,
        listen: false,
      ).fetchAssignedList(assignment_id: widget.assignment_id);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: buildConsumer(),
    );
  }

  Consumer<SubmissionRepository> buildConsumer() {
    return Consumer<SubmissionRepository>(
      builder: (context, submissionRepository, child) {
        if (submissionRepository.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (submissionRepository.errorMessage.isNotEmpty) {
          return buildErrorMessage(submissionRepository, context);
        }

        if (submissionRepository.submissionList.isEmpty && submissionRepository.assignedList.isEmpty) {
          return const Center(
            child: Text(
              "You haven't assign this to any students yet",
              textAlign: TextAlign.center,
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            submissionRepository.submissionList.isNotEmpty
                ? Text(
                    "Submitted",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                : const SizedBox(),
            submissionRepository.submissionList.isNotEmpty
                ? const Divider(
                    height: 10,
                  )
                : const SizedBox(),
            buildSubmittedListView(submissionRepository),
            submissionRepository.submissionList.isNotEmpty ? const SizedBox(height: 16) : const SizedBox(),
            Text(
              "Assigned",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const Divider(
              height: 10,
            ),
            buildAssignedListView(submissionRepository),
          ],
        );
      },
    );
  }

  Center buildErrorMessage(SubmissionRepository submissionRepository, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            submissionRepository.errorMessage,
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontSize: 20.0,
            ),
            textAlign: TextAlign.center,
          ),
          TextButton(
            onPressed: () => Provider.of<SubmissionRepository>(
              context,
              listen: false,
            ).fetchSubmissionList(assignment_id: widget.assignment_id),
            child: const Text(
              'Retry',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        ],
      ),
    );
  }

  ListView buildSubmittedListView(SubmissionRepository submissionRepository) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: submissionRepository.submissionList.length,
      itemBuilder: (context, index) {
        var submission = submissionRepository.submissionList[index];

        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => SubmissionPage(submission: submission),
            ),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              submission.student_name ?? '',
              style: const TextStyle(fontSize: 20.0),
            ),
            subtitle: Text(
              'Submitted at ${CustomFormatter.formatDateTime(submission.submitted_at)}',
            ),
            trailing: Text(
              '${submission.score}',
              style: const TextStyle(fontSize: 20.0),
            ),
          ),
        );
      },
    );
  }

  ListView buildAssignedListView(SubmissionRepository submissionRepository) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: submissionRepository.assignedList.length,
      itemBuilder: (context, index) {
        var assigned = submissionRepository.assignedList[index];

        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            '${assigned['full_name']}',
            style: const TextStyle(fontSize: 20.0),
          ),
          subtitle: const Text('Not turned in'),
        );
      },
    );
  }
}
