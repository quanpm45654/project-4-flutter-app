import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/repositories/class_repository.dart';
import 'package:project_4_flutter_app/utils/constants.dart';
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
                spacing: CustomSize.medium,
                children: [
                  Image.asset(CustomImagePath.noClassImage),
                  const Text(
                    'Create a class to get started',
                    style: TextStyle(fontSize: CustomFontSize.medium),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: classList.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: CustomSize.small),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: ListTile(
                  title: Text(
                    classList[index].name,
                    style: const TextStyle(
                      fontSize: CustomFontSize.medium,
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
