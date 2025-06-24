import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/utils/constants.dart';
import 'package:project_4_flutter_app/utils/functions.dart';
import 'package:project_4_flutter_app/repositories/assignment_repository.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/assignment/assignment_page.dart';

class HomeAssignmentListWidget extends StatelessWidget {
  const HomeAssignmentListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final assignmentRepository = AssignmentRepository();

    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Assignment',
              style: TextStyle(
                fontSize: CustomFontSize.medium, 
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        FutureBuilder(
          future: assignmentRepository.fetchAssignmentList(),
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.hasData) {
              final assignmentList = asyncSnapshot.requireData;

              if (assignmentList.isEmpty) {
                return const Center(
                  child: Text(
                    "Start creating assignments to your class",
                    style: TextStyle(fontSize: CustomFontSize.medium),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              return Expanded(
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
                              return AssignmentPage(assignment: assignmentList[index]);
                            },
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.only(right: CustomSize.medium),
                        child: Container(
                          width: 160,
                          padding: const EdgeInsets.all(CustomSize.medium),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                assignmentList[index].title,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: const TextStyle(
                                  fontSize: CustomFontSize.medium,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'Class name',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              const Divider(
                                height: 32.0,
                              ),
                              Row(
                                spacing: CustomSize.small,
                                children: [
                                  const Icon(Icons.access_time),
                                  Text(
                                    'Due ${CustomFormatter.formatDateTime(assignmentList[index].due_at)}',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else if (asyncSnapshot.hasError) {
              developer.log('${DateTime.now()}: ${asyncSnapshot.error}');
              return const Expanded(
                child: Center(
                  child: Text(
                    'There was an error, please try again later',
                    style: TextStyle(fontSize: CustomFontSize.medium),
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
    );
  }
}
