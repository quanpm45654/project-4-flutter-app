import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/utils/constants.dart';
import 'package:project_4_flutter_app/views/lecturer/widgets/home/home_assignment_list_widget.dart';
import 'package:project_4_flutter_app/views/lecturer/widgets/home/home_class_list_widget.dart';
import 'package:project_4_flutter_app/views/lecturer/widgets/lecturer_navigation_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
        ),
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(
            CustomSize.medium,
          ),
          child: Column(
            children: [
              HomeClassListWidget(),
              HomeAssignmentListWidget(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const LecturerNavigationBar(),
    );
  }
}
