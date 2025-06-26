import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/models/submission.dart';
import 'package:project_4_flutter_app/repositories/submission_repository.dart';
import 'package:project_4_flutter_app/utils/constants.dart';
import 'package:project_4_flutter_app/utils/functions.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/submission/submission_page.dart';

class SubmissionListWidget extends StatefulWidget {
  const SubmissionListWidget({super.key, required this.assignment_id});

  final int assignment_id;

  @override
  State<SubmissionListWidget> createState() => _SubmissionListWidgetState();
}

class _SubmissionListWidgetState extends State<SubmissionListWidget> {
  late final Future<List<Submission>> _future;

  @override
  void initState() {
    super.initState();
    final submissionRepository = SubmissionRepository();
    _future = submissionRepository.fetchSubmissionList(
      assignment_id: widget.assignment_id,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.hasData) {
          final submissionList = asyncSnapshot.requireData;

          return submissionList.isEmpty
              ? Center(
                  child: Text(
                    "You haven't assign this to any students yet",
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                )
              : Column(
                  children: [
                    Text(
                      "${submissionList.length} submitted",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: submissionList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<dynamic>(
                                builder: (context) {
                                  return const SubmissionPage();
                                },
                              ),
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.only(
                              bottom: CustomSize.medium,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(
                                CustomSize.medium,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        submissionList[index].student_name ?? '',
                                        style: Theme.of(context).textTheme.titleMedium,
                                      ),
                                      Text(
                                        submissionList[index].score ?? '',
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Submitted at ${CustomFormatter.formatDateTime2(submissionList[index].submitted_at)}',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
        } else if (asyncSnapshot.hasError) {
          developer.log('${DateTime.now()}: ${asyncSnapshot.error}');
          return Expanded(
            child: Center(
              child: Text(
                'There was an error, please try again later',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else {
          return const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
