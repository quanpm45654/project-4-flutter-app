import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/models/class.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/class/class_edit_page.dart';
import 'package:project_4_flutter_app/views/lecturer/widgets/class/class_assignment_list_widget.dart';
import 'package:project_4_flutter_app/views/lecturer/widgets/class/class_student_list_widget.dart';
import 'package:project_4_flutter_app/views/lecturer/widgets/lecturer_navigation_bar.dart';

class ClassPage extends StatefulWidget {
  const ClassPage({super.key, required this.classObject});

  final Class classObject;

  @override
  State<ClassPage> createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.classObject.class_name),
        actions: [
          MenuAnchor(
            builder: (context, controller, child) {
              return IconButton(
                onPressed: () => controller.isOpen ? controller.close() : controller.open(),
                icon: const Icon(Icons.more_vert_rounded),
              );
            },
            menuChildren: [
              MenuItemButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => ClassEditPage(classObject: widget.classObject),
                  ),
                ),
                child: const Text(
                  'Edit',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            const Tab(
              child: Text(
                'Student',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            const Tab(
              child: Text(
                'Assignment',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: TabBarView(
            controller: _tabController,
            children: [
              ClassStudentListWidget(class_id: widget.classObject.class_id),
              ClassAssignmentListWidget(class_id: widget.classObject.class_id),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const LecturerNavigationBar(),
    );
  }
}
