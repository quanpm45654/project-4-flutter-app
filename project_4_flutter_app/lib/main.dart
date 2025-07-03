import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/repositories/assignment_repository.dart';
import 'package:project_4_flutter_app/repositories/class_repository.dart';
import 'package:project_4_flutter_app/repositories/student_repository.dart';
import 'package:project_4_flutter_app/repositories/submission_repository.dart';
import 'package:project_4_flutter_app/states/lecturer_navigation_bar_state.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/class/class_list_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LecturerNavigationBarState(),
        ),
        ChangeNotifierProvider(
          create: (context) => AssignmentRepository(),
        ),
        ChangeNotifierProvider(
          create: (context) => ClassRepository(),
        ),
        ChangeNotifierProvider(
          create: (context) => StudentRepository(),
        ),
        ChangeNotifierProvider(
          create: (context) => SubmissionRepository(),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ClassListPage(),
    );
  }
}
