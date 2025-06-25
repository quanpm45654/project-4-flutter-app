import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/models/user.dart';
import 'package:project_4_flutter_app/repositories/student_repository.dart';
import 'package:project_4_flutter_app/utils/constants.dart';

class StudentListWidget extends StatefulWidget {
  const StudentListWidget({super.key, required this.class_id});

  final int class_id;

  @override
  State<StudentListWidget> createState() => _StudentListWidgetState();
}

class _StudentListWidgetState extends State<StudentListWidget> {
  late final Future<List<User>> _future;

  @override
  void initState() {
    super.initState();
    final studentRepository = StudentRepository();
    _future = studentRepository.fetchStudentList(
      class_id: widget.class_id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.hasData) {
          final studentList = asyncSnapshot.requireData;

          return Column(
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
              const SizedBox(
                height: 8,
              ),

              studentList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: CustomSize.medium,
                        children: [
                          Image.asset(
                            CustomImagePath.noStudentImage,
                          ),
                          const Text(
                            "Add students to your class",
                            style: TextStyle(
                              fontSize: CustomFontSize.medium,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: studentList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const CircleAvatar(
                            child: Icon(
                              Icons.person,
                            ),
                          ),
                          title: Text(
                            studentList[index].full_name,
                          ),
                          subtitle: Text(
                            studentList[index].email,
                          ),
                          trailing: MenuAnchor(
                            builder: (context, controller, child) {
                              return IconButton(
                                onPressed: () {
                                  controller.isOpen ? controller.close() : controller.open();
                                },
                                icon: const Icon(
                                  Icons.more_vert_rounded,
                                ),
                              );
                            },
                            menuChildren: [
                              MenuItemButton(
                                onPressed: () {},
                                child: const Text(
                                  'Remove student',
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ],
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
