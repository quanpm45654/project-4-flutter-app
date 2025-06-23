import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/repositories/student_repository.dart';
import 'package:project_4_flutter_app/utils/constants.dart';

class StudentListWidget extends StatelessWidget {
  const StudentListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final userRepository = StudentRepository();

    return FutureBuilder(
      future: userRepository.fetchStudentList(1),
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.hasData) {
          final studentList = asyncSnapshot.requireData;

          return SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Student',
                      style: TextStyle(
                        fontSize: CustomFontSize.medium,
                      ),
                    ),
                    Text('${studentList.length}'),
                  ],
                ),
                const Divider(),

                studentList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: CustomSize.medium,
                          children: [
                            Image.asset(CustomImagePath.noStudentImage),
                            const Text("Add students to your class"),
                          ],
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: studentList.length - 1,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                            title: Text(
                              studentList[index].full_name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            subtitle: Text(
                              studentList[index].email,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          );
                        },
                      ),
              ],
            ),
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
