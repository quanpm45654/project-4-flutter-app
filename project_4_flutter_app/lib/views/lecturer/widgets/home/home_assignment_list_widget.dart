import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/models/assignment.dart';
import 'package:project_4_flutter_app/repositories/assignment_repository.dart';
import 'package:project_4_flutter_app/states/lecturer_navigation_bar_state.dart';
import 'package:project_4_flutter_app/utils/constants.dart';
import 'package:project_4_flutter_app/utils/functions.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/assignment/assignment_list_page.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/assignment/assignment_page.dart';
import 'package:provider/provider.dart';

class HomeAssignmentListWidget extends StatefulWidget {
  const HomeAssignmentListWidget({super.key});

  @override
  State<HomeAssignmentListWidget> createState() => _HomeAssignmentListWidgetState();
}

class _HomeAssignmentListWidgetState extends State<HomeAssignmentListWidget> {
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
    final navigationBarState = Provider.of<LecturerNavigationBarState>(context);

    return SizedBox(
      height: 240,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Assignment',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (context) {
                        navigationBarState.setIndex(2);
                        return const AssignmentListPage();
                      },
                    ),
                  );
                },
                child: Text(
                  'View all',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          FutureBuilder(
            future: _future,
            builder: (context, asyncSnapshot) {
              if (asyncSnapshot.hasData) {
                final assignmentList = asyncSnapshot.requireData;

                if (assignmentList.isEmpty) {
                  return Flexible(
                    child: Center(
                      child: Text(
                        "You haven't created any assignments yet",
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                } else {
                  return Flexible(
                    child: SizedBox(
                      height: 160,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
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
                                right: CustomSize.medium,
                              ),
                              child: Container(
                                width: 160,
                                padding: const EdgeInsets.all(
                                  CustomSize.medium,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      assignmentList[index].class_name ?? '',
                                    ),
                                    Text(
                                      assignmentList[index].title,
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                    const Spacer(),
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
                      ),
                    ),
                  );
                }
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
          ),
        ],
      ),
    );
  }
}
