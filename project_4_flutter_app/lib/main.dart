import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/utils/custom_theme.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/home/home_page.dart';
import 'package:project_4_flutter_app/states/lecturer_navigation_bar_state.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LecturerNavigationBarState(),
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
      theme: CustomTheme.lightTheme,
      darkTheme: CustomTheme.darkTheme,
      home: const HomePage(),
    );
  }
}
