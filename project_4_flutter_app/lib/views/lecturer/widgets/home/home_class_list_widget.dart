import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/utils/constants.dart';
import 'package:project_4_flutter_app/repositories/class_repository.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/student/student_list_page.dart';

class HomeClassListWidget extends StatelessWidget {
  const HomeClassListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final classRepository = ClassRepository();

    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Class',
              style: TextStyle(
                fontSize: CustomFontSize.medium,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        FutureBuilder(
          future: classRepository.fetchClassList(1),
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.hasData) {
              final classList = asyncSnapshot.requireData;

              if (classList.isEmpty) {
                return const Expanded(
                  child: Center(
                    child: Text(
                      'Create a class to get started',
                      style: TextStyle(
                        fontSize: CustomFontSize.medium,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              return Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: classList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
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
                      child: Card(
                        margin: const EdgeInsets.symmetric(horizontal: CustomSize.small),
                        child: Container(
                          width: 160,
                          padding: const EdgeInsets.all(CustomSize.medium),
                          child: Column(
                            children: [
                              Text(
                                classList[index].name,
                                style: const TextStyle(
                                  fontSize: CustomFontSize.medium,
                                  fontWeight: FontWeight.w500,
                                ),
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
