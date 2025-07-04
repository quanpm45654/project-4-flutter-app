import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/teacher/pages/class/class_list_page.dart';
import 'package:project_4_flutter_app/teacher/repositories/assignment_repository.dart';
import 'package:project_4_flutter_app/teacher/repositories/class_repository.dart';
import 'package:project_4_flutter_app/teacher/repositories/feedback_repository.dart';
import 'package:project_4_flutter_app/teacher/repositories/student_repository.dart';
import 'package:project_4_flutter_app/teacher/repositories/submission_repository.dart';
import 'package:project_4_flutter_app/teacher/states/lecturer_navigation_bar_state.dart';
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
        ChangeNotifierProvider(
          create: (context) => FeedbackRepository(),
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
      title: 'Assignment App',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      home: const ClassListPage(),
    );
  }
}
