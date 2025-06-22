import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/repositories/assignment_repository.dart';
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
                spacing: 16.0,
                children: [
                  Image.asset('assets/images/studying.png'),
                  const Text("Start creating assignments to your class"),
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
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          assignmentList[index].title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Class name',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const Divider(
                          height: 32.0,
                        ),
                        Row(
                          spacing: 8.0,
                          children: [
                            const Icon(Icons.access_time),
                            Text('Due ${dateFormatter(assignmentList[index].due_at)}'),
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
          return const Center(
            child: Text(
              'There was an error, please try again later',
              textAlign: TextAlign.center,
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
