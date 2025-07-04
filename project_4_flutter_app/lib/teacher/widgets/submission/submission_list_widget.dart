import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/teacher/models/submission.dart';
import 'package:project_4_flutter_app/teacher/pages/submission/submission_page.dart';
import 'package:project_4_flutter_app/teacher/repositories/assignment_repository.dart';
import 'package:project_4_flutter_app/teacher/repositories/submission_repository.dart';
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final assignmentRepository = Provider.of<AssignmentRepository>(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Consumer<SubmissionRepository>(
        builder: (context, submissionRepository, child) {
          var gradedList = submissionRepository.submissionList
              .where((a) => a.grade_status == 'Graded')
              .toList();
          var submissionList = submissionRepository.submissionList
              .where((a) => a.submit_status == 'Submitted' && a.grade_status == null)
              .toList();
          var assignedList = submissionRepository.submissionList
              .where((a) => a.submit_status == 'Assigned')
              .toList();

          if (submissionRepository.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (submissionRepository.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    submissionRepository.errorMessage,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 18.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  TextButton(
                    onPressed: () async {
                      await submissionRepository.fetchSubmissionList(widget.assignment_id);
                    },
                    child: const Text(
                      'Retry',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ],
              ),
            );
          }
          if (submissionRepository.submissionList.isEmpty) {
            return const Center(
              child: Text(
                "You haven't assign this to any students yet",
                textAlign: TextAlign.center,
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await submissionRepository.fetchSubmissionList(widget.assignment_id);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Graded",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      '${gradedList.length}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
                const Divider(),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: gradedList.length,
                  itemBuilder: (context, index) {
                    Submission submission = gradedList[index];

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
                          style: const TextStyle(fontSize: 18.0),
                        ),
                        subtitle:
                            submission.submitted_at!.isAfter(
                              assignmentRepository.assignmentList
                                  .firstWhere(
                                    (a) => a.id == submission.assignment_id,
                                  )
                                  .due_date,
                            )
                            ? Text(
                                'Done late',
                                style: TextStyle(
                                  color: Colors.red.shade900,
                                ),
                              )
                            : Text(
                                'Submitted',
                                style: TextStyle(color: Colors.green.shade900),
                              ),
                        trailing: Text(
                          '${submission.score}/10',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.green.shade900,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Submitted",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      '${submissionList.length}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
                const Divider(),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: submissionList.length,
                  itemBuilder: (context, index) {
                    Submission submission = submissionList[index];

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
                          style: const TextStyle(fontSize: 18.0),
                        ),
                        subtitle:
                            submission.submitted_at!.isAfter(
                              assignmentRepository.assignmentList
                                  .firstWhere((a) => a.id == submission.assignment_id)
                                  .due_date,
                            )
                            ? Text(
                                'Done late',
                                style: TextStyle(color: Colors.red.shade900),
                              )
                            : Text(
                                'Submitted',
                                style: TextStyle(color: Colors.green.shade900),
                              ),
                        trailing: Text(
                          'Not graded',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.green.shade900,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Assigned",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      '${assignedList.length}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
                const Divider(),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: assignedList.length,
                  itemBuilder: (context, index) {
                    Submission assigned = assignedList[index];

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        '${assigned.student_name}',
                        style: const TextStyle(fontSize: 18.0),
                      ),
                      subtitle: const Text('Not submitted'),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
