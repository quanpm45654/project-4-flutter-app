import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/class.dart';
import '../../repositories/class_repository.dart';
import '../../widgets/assignment/assignment_list_widget.dart';
import '../../widgets/student/student_list_widget.dart';
import '../../widgets/teacher_navigation_bar.dart';

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
            title: Text(widget.classObject.class_name ?? ''),
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
                AssignmentListWidget(class_id: widget.classObject.id),
                StudentListWidget(class_id: widget.classObject.id),
              ],
            ),
          ),
          bottomNavigationBar: const TeacherNavigationBar(),
        );
      },
    );
  }
}
