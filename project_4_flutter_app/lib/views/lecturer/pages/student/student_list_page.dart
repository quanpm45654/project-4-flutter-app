import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/student/student_add_page.dart';
import 'package:project_4_flutter_app/views/lecturer/widgets/lecturer_navigation_bar.dart';
import 'package:project_4_flutter_app/views/lecturer/widgets/student/student_list_widget.dart';

class StudentListPage extends StatelessWidget {
  const StudentListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class name'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: const StudentListWidget(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<dynamic>(
              builder: (context) {
                return const StudentAddPage(title: 'Add student');
              },
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add student'),
      ),
      bottomNavigationBar: const LecturerNavigationBar(),
    );
  }
}
