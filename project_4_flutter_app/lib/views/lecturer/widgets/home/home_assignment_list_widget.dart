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
  Widget build(BuildContext context) {
    final navigationBarState = Provider.of<LecturerNavigationBarState>(context);

    return SizedBox(
      height: 280,
      child: Column(
        spacing: CustomSize.medium,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Assignment',
                style: TextStyle(
                  fontSize: CustomFontSize.medium,
                  fontWeight: FontWeight.w500,
                ),
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
                  return const Flexible(
                    child: Center(
                      child: Text(
                        "Start creating assignments to your class",
                        style: TextStyle(
                          fontSize: CustomFontSize.medium,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                } else {
                  return Flexible(
                    child: SizedBox(
                      height: 200,
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
                                width: 200,
                                padding: const EdgeInsets.all(
                                  CustomSize.medium,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      assignmentList[index].class_name,
                                    ),
                                    Text(
                                      assignmentList[index].title,
                                      style: const TextStyle(
                                        fontSize: CustomFontSize.medium,
                                        fontWeight: FontWeight.bold,
                                      ),
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
                return const Flexible(
                  child: Center(
                    child: Text(
                      'There was an error, please try again later',
                      style: TextStyle(
                        fontSize: CustomFontSize.medium,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              } else {
                return const Flexible(
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
