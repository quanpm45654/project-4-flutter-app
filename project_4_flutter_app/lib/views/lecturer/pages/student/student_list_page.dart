import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/utils/constants.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/class/class_create_edit_page.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/student/student_add_page.dart';
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (context) {
                    return const ClassCreateEditPage(title: 'Edit class');
                  },
                ),
              );
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(CustomSize.medium),
          child: const StudentListWidget(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
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
        child: const Icon(Icons.add),
      ),
    );
  }
}
