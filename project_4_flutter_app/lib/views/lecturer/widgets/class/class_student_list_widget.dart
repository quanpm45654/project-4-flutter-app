import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/models/user.dart';
import 'package:project_4_flutter_app/repositories/student_repository.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/student/student_add_page.dart';

class ClassStudentListWidget extends StatefulWidget {
  const ClassStudentListWidget({super.key, required this.class_id});

  final int class_id;

  @override
  State<ClassStudentListWidget> createState() => _ClassStudentListWidgetState();
}

class _ClassStudentListWidgetState extends State<ClassStudentListWidget> {
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.hasData) {
          final studentList = asyncSnapshot.requireData;

          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: double.maxFinite,
                  height: 48,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (context) {
                            return const StudentAddPage(
                              title: 'Add student',
                            );
                          },
                        ),
                      );
                    },
                    child: const Text(
                      'Add student',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Text(
                      'Student',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Spacer(),
                    Text('${studentList.length}'),
                    const SizedBox(
                      width: 16,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),

                studentList.isEmpty
                    ? Center(
                        child: Text(
                          "You haven't added any students in this class yet",
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: studentList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(
                              Icons.person_rounded,
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
            ),
          );
        } else if (asyncSnapshot.hasError) {
          developer.log('${DateTime.now()}: ${asyncSnapshot.error}');
          return Center(
            child: Text(
              'There was an error, please try again later',
              style: Theme.of(context).textTheme.bodyLarge,
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
