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
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildConsumer();
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

        if (submissionRepository.submissionList.isEmpty) {
          return const Center(
            child: Text(
              "You haven't assign this to any students yet",
              style: TextStyle(fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
          );
        }

        return Column(
          children: [
            Text(
              "${submissionRepository.submissionList.length} submitted",
              style: const TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 8),
            buildListView(submissionRepository),
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

  ListView buildListView(SubmissionRepository submissionRepository) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: submissionRepository.submissionList.length,
      itemBuilder: (context, index) {
        final submission = submissionRepository.submissionList[index];

        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => SubmissionPage(submission: submission),
            ),
          ),
          child: ListTile(
            title: Text(
              submission.student_name ?? '',
              style: const TextStyle(fontSize: 20.0),
            ),
            subtitle: Text(
              'Submitted at ${CustomFormatter.formatDateTime(submission.submitted_at)}',
              style: const TextStyle(fontSize: 16.0),
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
}
