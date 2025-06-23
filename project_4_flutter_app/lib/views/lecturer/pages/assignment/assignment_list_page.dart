import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/utils/constants.dart';
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
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: CustomSize.medium),
          child: const AssignmentListWidget(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
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
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const LecturerNavigationBar(),
    );
  }
}
