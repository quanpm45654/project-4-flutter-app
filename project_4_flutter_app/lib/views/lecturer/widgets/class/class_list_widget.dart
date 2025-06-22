import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/repositories/class_repository.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/class/class_create_edit_page.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/student/student_list_page.dart';

class ClassListWidget extends StatelessWidget {
  const ClassListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final classRepository = ClassRepository();

    return FutureBuilder(
      future: classRepository.fetchClassList(1),
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.hasData) {
          final classList = asyncSnapshot.requireData;

          if (classList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 16.0,
                children: [
                  Image.asset('assets/images/class.png'),
                  const Text('Create a class to get started'),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: classList.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: ListTile(
                  title: Text(
                    classList[index].name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: MenuAnchor(
                    builder: (context, controller, child) {
                      return IconButton(
                        onPressed: () {
                          controller.isOpen ? controller.close() : controller.open();
                        },
                        icon: const Icon(Icons.more_vert),
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
                        child: const Text('Edit class'),
                      ),
                    ],
                  ),
                  isThreeLine: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (context) {
                          return const StudentListPage();
                        },
                      ),
                    );
                  },
                ),
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
