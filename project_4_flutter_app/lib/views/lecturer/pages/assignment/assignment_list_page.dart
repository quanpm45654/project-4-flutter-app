import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/assignment/assignment_create_edit_page.dart';
import 'package:project_4_flutter_app/views/lecturer/widgets/assignment/assignment_list_widget.dart';
import 'package:project_4_flutter_app/views/lecturer/widgets/lecturer_navigation_bar.dart';

class AssignmentListPage extends StatelessWidget {
  const AssignmentListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignment'),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: const AssignmentListWidget(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<dynamic>(
              builder: (context) {
                return const AssignmentCreateEditPage(title: 'Create assignment');
              },
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Create assignment'),
      ),
      bottomNavigationBar: const LecturerNavigationBar(),
    );
  }
}
