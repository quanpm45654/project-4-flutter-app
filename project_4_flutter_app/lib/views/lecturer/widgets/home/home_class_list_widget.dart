import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/models/class.dart';
import 'package:project_4_flutter_app/repositories/class_repository.dart';
import 'package:project_4_flutter_app/states/lecturer_navigation_bar_state.dart';
import 'package:project_4_flutter_app/utils/constants.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/class/class_list_page.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/student/student_list_page.dart';
import 'package:provider/provider.dart';

class HomeClassListWidget extends StatefulWidget {
  const HomeClassListWidget({super.key});

  @override
  State<HomeClassListWidget> createState() => _HomeClassListWidgetState();
}

class _HomeClassListWidgetState extends State<HomeClassListWidget> {
  late final Future<List<Class>> _future;

  @override
  void initState() {
    super.initState();
    final classRepository = ClassRepository();
    _future = classRepository.fetchClassList(lecturer_id: 2);
  }

  @override
  Widget build(BuildContext context) {
    final navigationBarState = Provider.of<LecturerNavigationBarState>(context);

    return SizedBox(
      height: 280,
      child: Column(
        spacing: CustomSize.medium,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Class',
                style: TextStyle(
                  fontSize: CustomFontSize.medium,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (context) {
                        navigationBarState.setIndex(1);
                        return const ClassListPage();
                      },
                    ),
                  );
                },
                child: Text(
                  'View all',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          FutureBuilder(
            future: _future,
            builder: (context, asyncSnapshot) {
              if (asyncSnapshot.hasData) {
                final classList = asyncSnapshot.requireData;

                if (classList.isEmpty) {
                  return const Flexible(
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
                } else {
                  return Flexible(
                    child: SizedBox(
                      height: 200,
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
                                right: CustomSize.medium,
                              ),
                              child: Container(
                                width: 200,
                                padding: const EdgeInsets.all(
                                  CustomSize.medium,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      classList[index].class_name,
                                      style: const TextStyle(
                                        fontSize: CustomFontSize.medium,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      classList[index].class_code,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }
              } else if (asyncSnapshot.hasError) {
                developer.log('${DateTime.now()}: ${asyncSnapshot.error}');
                return const Flexible(
                  child: Center(
                    child: Text(
                      'There was an error, please try again later',
                      style: TextStyle(
                        fontSize: CustomFontSize.medium,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              } else {
                return const Flexible(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
