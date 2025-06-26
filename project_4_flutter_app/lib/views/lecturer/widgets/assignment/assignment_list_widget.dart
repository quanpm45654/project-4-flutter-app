import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/models/assignment.dart';
import 'package:project_4_flutter_app/repositories/assignment_repository.dart';
import 'package:project_4_flutter_app/utils/constants.dart';
import 'package:project_4_flutter_app/utils/functions.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/assignment/assignment_create_edit_page.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/assignment/assignment_page.dart';

class AssignmentListWidget extends StatefulWidget {
  const AssignmentListWidget({super.key});

  @override
  State<AssignmentListWidget> createState() => _AssignmentListWidgetState();
}

class _AssignmentListWidgetState extends State<AssignmentListWidget> {
  late final Future<List<Assignment>> _future;

  @override
  void initState() {
    super.initState();
    final assignmentRepository = AssignmentRepository();
    _future = assignmentRepository.fetchAssignmentList(lecturer_id: 2);
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
          final assignmentList = asyncSnapshot.requireData;

          return assignmentList.isEmpty
              ? Center(
                  child: Text(
                    "You haven't created any assignments yet",
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  itemCount: assignmentList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<dynamic>(
                            builder: (context) {
                              return AssignmentPage(
                                assignment: assignmentList[index],
                              );
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
                              Text(
                                assignmentList[index].class_name ?? '',
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    assignmentList[index].title,
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  MenuAnchor(
                                    builder: (context, controller, child) {
                                      return IconButton(
                                        onPressed: () {
                                          controller.isOpen
                                              ? controller.close()
                                              : controller.open();
                                        },
                                        icon: const Icon(
                                          Icons.more_vert_rounded,
                                        ),
                                      );
                                    },
                                    menuChildren: [
                                      MenuItemButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute<dynamic>(
                                              builder: (context) {
                                                return AssignmentCreateEditPage(
                                                  title: 'Edit assignment',
                                                  assignment: assignmentList[index],
                                                );
                                              },
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          'Edit',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Text(
                                'Due ${CustomFormatter.formatDateTime(assignmentList[index].due_at)}',
                                style: DateTime.now().isAfter(assignmentList[index].due_at)
                                    ? TextStyle(
                                        color: Theme.of(context).colorScheme.error,
                                      )
                                    : const TextStyle(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
        } else if (asyncSnapshot.hasError) {
          developer.log('${DateTime.now()}: ${asyncSnapshot.error}');
          return Center(
            child: Expanded(
              child: Text(
                'There was an error, please try again later',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
