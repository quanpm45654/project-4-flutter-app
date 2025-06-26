import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/models/class.dart';
import 'package:project_4_flutter_app/repositories/class_repository.dart';
import 'package:project_4_flutter_app/states/lecturer_navigation_bar_state.dart';
import 'package:project_4_flutter_app/utils/constants.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/class/class_list_page.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/class/class_page.dart';
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navigationBarState = Provider.of<LecturerNavigationBarState>(context);

    return SizedBox(
      height: 240,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Class',
                style: Theme.of(context).textTheme.titleMedium,
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
                  return Flexible(
                    child: Center(
                      child: Text(
                        "You haven't added any classes yet",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  );
                } else {
                  return Flexible(
                    child: SizedBox(
                      height: 160,
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
                                    return ClassPage(
                                      classObject: classList[index],
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
                                width: 160,
                                padding: const EdgeInsets.all(
                                  CustomSize.medium,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      classList[index].class_name,
                                      style: Theme.of(context).textTheme.titleMedium,
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
                      ),
                    ),
                  );
                }
              } else if (asyncSnapshot.hasError) {
                developer.log('${DateTime.now()}: ${asyncSnapshot.error}');
                return Expanded(
                  child: Center(
                    child: Text(
                      'There was an error, please try again later',
                      style: Theme.of(context).textTheme.bodyLarge,
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
      ),
    );
  }
}
