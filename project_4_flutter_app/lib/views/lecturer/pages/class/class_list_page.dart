import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/class/class_create_edit_page.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: const ClassListWidget(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<dynamic>(
              builder: (context) {
                return const ClassCreateEditPage(title: 'Create class');
              },
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Create class'),
      ),
      bottomNavigationBar: const LecturerNavigationBar(),
    );
  }
}
