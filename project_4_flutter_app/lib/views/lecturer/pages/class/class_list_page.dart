import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/views/lecturer/widgets/class/class_list_widget.dart';
import 'package:project_4_flutter_app/views/lecturer/widgets/lecturer_navigation_bar.dart';

class ClassListPage extends StatelessWidget {
  const ClassListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class'),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: const ClassListWidget(),
        ),
      ),
      bottomNavigationBar: const LecturerNavigationBar(),
    );
  }
}
