import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/models/submission.dart';
import 'package:project_4_flutter_app/repositories/assignment_repository.dart';
import 'package:project_4_flutter_app/repositories/submission_repository.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/submission/submission_page.dart';
import 'package:provider/provider.dart';

class SubmissionListWidget extends StatefulWidget {
  const SubmissionListWidget({super.key, required this.assignment_id});

  final int assignment_id;

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
      ).fetchSubmissionList(widget.assignment_id);
      Provider.of<SubmissionRepository>(
        context,
        listen: false,
      ).fetchAssignedList(widget.assignment_id);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var assignmentRepository = Provider.of<AssignmentRepository>(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: buildConsumer(assignmentRepository),
    );
  }

  Consumer<SubmissionRepository> buildConsumer(
    AssignmentRepository assignmentRepository,
  ) {
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

        if (submissionRepository.submissionList.isEmpty &&
            submissionRepository.assignedList.isEmpty) {
          return const Center(
            child: Text(
              "You haven't assign this to any students yet",
              textAlign: TextAlign.center,
            ),
          );
        }

        var submittedSubmissionList = submissionRepository.submissionList
            .where((a) => a.score == null)
            .toList();
        var gradedSubmissionList = submissionRepository.submissionList
            .where((a) => a.score != null)
            .toList();

        return RefreshIndicator(
          onRefresh: () async {
            await submissionRepository.fetchSubmissionList(
              widget.assignment_id,
            );
            await submissionRepository.fetchAssignedList(widget.assignment_id);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              gradedSubmissionList.isNotEmpty
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Graded",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Text(
                          '${gradedSubmissionList.length}',
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ],
                    )
                  : const SizedBox(),
              gradedSubmissionList.isNotEmpty
                  ? const Divider(height: 10)
                  : const SizedBox(),
              buildGradedListView(
                gradedSubmissionList,
                assignmentRepository,
              ),
              gradedSubmissionList.isNotEmpty
                  ? const SizedBox(height: 16.0)
                  : const SizedBox(),
              submittedSubmissionList.isNotEmpty
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Graded",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Text(
                          '${submittedSubmissionList.where(
                            (a) => a.score != null,
                          ).length}',
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ],
                    )
                  : const SizedBox(),
              submittedSubmissionList.isNotEmpty
                  ? const Divider(height: 10)
                  : const SizedBox(),
              buildSubmittedListView(
                submittedSubmissionList,
                assignmentRepository,
              ),
              submittedSubmissionList.isNotEmpty
                  ? const SizedBox(height: 16.0)
                  : const SizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Assigned",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    '${submissionRepository.assignedList.length}',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              const Divider(height: 10),
              buildAssignedListView(submissionRepository),
            ],
          ),
        );
      },
    );
  }

  Center buildErrorMessage(
    SubmissionRepository submissionRepository,
    BuildContext context,
  ) {
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
            onPressed: () async {
              await submissionRepository.fetchSubmissionList(
                widget.assignment_id,
              );
              await submissionRepository.fetchAssignedList(
                widget.assignment_id,
              );
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  ListView buildGradedListView(
    List<Submission> gradedSubmissionList,
    AssignmentRepository assignmentRepository,
  ) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: gradedSubmissionList.length,
      itemBuilder: (context, index) {
        var submission = gradedSubmissionList.toList()[index];

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
            subtitle:
                submission.submitted_at.isAfter(
                  assignmentRepository.assignmentList
                      .firstWhere(
                        (a) => a.assignment_id == submission.assignment_id,
                      )
                      .due_at,
                )
                ? Text(
                    'Done late',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  )
                : const Text(
                    'Turned in',
                    style: TextStyle(color: Colors.green),
                  ),
            trailing: Text(
              '${submission.score ?? '...'}/${assignmentRepository.assignmentList.firstWhere(
                (a) => a.assignment_id == submission.assignment_id,
              ).max_score}',
              style: const TextStyle(
                fontSize: 20.0,
                color: Colors.green,
              ),
            ),
          ),
        );
      },
    );
  }

  ListView buildSubmittedListView(
    List<Submission> submittedSubmissionList,
    AssignmentRepository assignmentRepository,
  ) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: submittedSubmissionList.length,
      itemBuilder: (context, index) {
        var submission = submittedSubmissionList[index];

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
            subtitle:
                submission.submitted_at.isAfter(
                  assignmentRepository.assignmentList
                      .firstWhere(
                        (a) => a.assignment_id == submission.assignment_id,
                      )
                      .due_at,
                )
                ? Text(
                    'Done late',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  )
                : const Text(
                    'Turned in',
                    style: TextStyle(color: Colors.green),
                  ),
            trailing: Text(
              '${submission.score ?? '...'}/${assignmentRepository.assignmentList.firstWhere(
                (a) => a.assignment_id == submission.assignment_id,
              ).max_score}',
              style: const TextStyle(
                fontSize: 20.0,
                color: Colors.green,
              ),
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
