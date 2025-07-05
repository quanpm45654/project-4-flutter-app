import 'package:flutter/material.dart';

import '../../widgets/class/class_list_widget.dart';
import '../../widgets/teacher_navigation_bar.dart';

class ClassListPage extends StatelessWidget {
  const ClassListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class'),
      ),
      body: const SafeArea(
        child: ClassListWidget(),
      ),
      bottomNavigationBar: const TeacherNavigationBar(),
    );
  }
}
