import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/utils/constants.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/student/student_add_page.dart';
import 'package:project_4_flutter_app/views/lecturer/widgets/lecturer_navigation_bar.dart';
import 'package:project_4_flutter_app/views/lecturer/widgets/student/student_list_widget.dart';

class StudentListPage extends StatelessWidget {
  const StudentListPage({super.key, required this.class_id, required this.class_name});

  final int class_id;
  final String class_name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          class_name,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(
            CustomSize.medium,
          ),
          child: StudentListWidget(
            class_id: class_id,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<dynamic>(
              builder: (context) {
                return const StudentAddPage(
                  title: 'Add student',
                );
              },
            ),
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      bottomNavigationBar: const LecturerNavigationBar(),
    );
  }
}
