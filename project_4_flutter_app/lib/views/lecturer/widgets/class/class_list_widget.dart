import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/models/class.dart';
import 'package:project_4_flutter_app/repositories/class_repository.dart';
import 'package:project_4_flutter_app/utils/constants.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/class/class_create_edit_page.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/class/class_page.dart';

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
  void dispose() {
    super.dispose();
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
                  child: Text(
                    "You haven't added any classes yet",
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
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
                              return ClassPage(
                                classObject: classList[index],
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    classList[index].class_name,
                                    style: Theme.of(context).textTheme.titleMedium,
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
                              Text(
                                classList[index].class_code,
                              ),
                              Text(
                                classList[index].semester,
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
