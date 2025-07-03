import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/models/class.dart';
import 'package:project_4_flutter_app/repositories/class_repository.dart';
import 'package:project_4_flutter_app/views/lecturer/widgets/assignment/assignment_list_widget.dart';
import 'package:project_4_flutter_app/views/lecturer/widgets/lecturer_navigation_bar.dart';
import 'package:project_4_flutter_app/views/lecturer/widgets/student/student_list_widget.dart';
import 'package:provider/provider.dart';

class ClassPage extends StatefulWidget {
  const ClassPage({super.key, required this.classObject});

  final Class classObject;

  @override
  State<ClassPage> createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ClassRepository>(
      builder: (context, classRepository, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              classRepository.classList
                  .firstWhere((a) => a.class_id == widget.classObject.class_id)
                  .class_name,
            ),
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                const Tab(
                  child: Text('Assignment'),
                ),
                const Tab(
                  child: Text('Student'),
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: TabBarView(
              controller: _tabController,
              children: [
                AssignmentListWidget(class_id: widget.classObject.class_id),
                StudentListWidget(class_id: widget.classObject.class_id),
              ],
            ),
          ),
          bottomNavigationBar: const LecturerNavigationBar(),
        );
      },
    );
  }
}
