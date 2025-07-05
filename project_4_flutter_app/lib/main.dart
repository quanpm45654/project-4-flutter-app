import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'teacher/pages/class/class_list_page.dart';
import 'teacher/repositories/assignment_repository.dart';
import 'teacher/repositories/class_repository.dart';
import 'teacher/repositories/feedback_repository.dart';
import 'teacher/repositories/student_repository.dart';
import 'teacher/repositories/submission_repository.dart';
import 'teacher/repositories/teacher_repository.dart';
import 'teacher/states/lecturer_navigation_bar_state.dart';

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
          create: (context) => TeacherRepository(),
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
      themeMode: ThemeMode.system,
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
