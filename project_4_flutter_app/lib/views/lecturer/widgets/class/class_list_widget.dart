import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/models/class.dart';
import 'package:project_4_flutter_app/repositories/class_repository.dart';
import 'package:project_4_flutter_app/utils/constants.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/class/class_create_edit_page.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/student/student_list_page.dart';

class ClassListWidget extends StatefulWidget {
  const ClassListWidget({super.key});

  @override
  State<ClassListWidget> createState() => _ClassListWidgetState();
}

class _ClassListWidgetState extends State<ClassListWidget> {
  late final Future<List<Class>> _future;

  @override
  void initState() {
    super.initState();
    final classRepository = ClassRepository();
    _future = classRepository.fetchClassList(lecturer_id: 2);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.hasData) {
          final classList = asyncSnapshot.requireData;

          return classList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: CustomSize.medium,
                    children: [
                      Image.asset(
                        CustomImagePath.noClassImage,
                      ),
                      const Text(
                        'Create a class to get started',
                        style: TextStyle(
                          fontSize: CustomFontSize.medium,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: classList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<dynamic>(
                            builder: (context) {
                              return StudentListPage(
                                class_id: classList[index].class_id,
                                class_name: classList[index].class_name,
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
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    classList[index].class_name,
                                    style: const TextStyle(
                                      fontSize: CustomFontSize.medium,
                                      fontWeight: FontWeight.w500,
                                    ),
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
                                                return ClassCreateEditPage(
                                                  title: 'Edit class',
                                                  classObject: classList[index],
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
                              Row(
                                children: [
                                  Text(
                                    classList[index].class_code,
                                  ),
                                ],
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  CustomImagePath.errorImage,
                ),
                const Text(
                  'There was an error, please try again later',
                  style: TextStyle(
                    fontSize: CustomFontSize.medium,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
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
