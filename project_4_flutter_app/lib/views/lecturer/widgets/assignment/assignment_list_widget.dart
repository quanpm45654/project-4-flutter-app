import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/repositories/assignment_repository.dart';
import 'package:project_4_flutter_app/utils/constants.dart';
import 'package:project_4_flutter_app/utils/functions.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/assignment/assignment_page.dart';

class AssignmentListWidget extends StatelessWidget {
  const AssignmentListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final assignmentRepository = AssignmentRepository();

    return FutureBuilder(
      future: assignmentRepository.fetchAssignmentList(),
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.hasData) {
          final assignmentList = asyncSnapshot.requireData;

          if (assignmentList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: CustomSize.medium,
                children: [
                  Image.asset(CustomImagePath.noAssignmentImage),
                  const Text(
                    "Start creating assignments to your class",
                    style: TextStyle(fontSize: CustomFontSize.medium),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: assignmentList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  margin: const EdgeInsets.only(bottom: CustomSize.medium),
                  child: Container(
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
              );
            },
          );
        } else if (asyncSnapshot.hasError) {
          developer.log('${DateTime.now()}: ${asyncSnapshot.error}');
          return SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Image.asset(CustomImagePath.errorImage),
                  const Text(
                    'There was an error, please try again later',
                    style: TextStyle(fontSize: CustomFontSize.medium),
                    textAlign: TextAlign.center,
                  ),
                ],
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
