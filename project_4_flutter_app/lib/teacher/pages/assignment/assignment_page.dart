import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/assignment.dart';
import '../../repositories/assignment_repository.dart';
import '../../widgets/assignment/assignment_widget.dart';
import '../../widgets/submission/submission_list_widget.dart';

class AssignmentPage extends StatefulWidget {
  const AssignmentPage({super.key, required this.assignment});

  final Assignment assignment;

  @override
  State<AssignmentPage> createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentPage> with SingleTickerProviderStateMixin {
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
    return Consumer<AssignmentRepository>(
      builder: (context, assignmentRepository, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Assignment'),
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                const Tab(
                  child: Text('Instruction'),
                ),
                const Tab(
                  child: Text('Student work'),
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: TabBarView(
              controller: _tabController,
              children: [
                AssignmentWidget(assignment: widget.assignment),
                SubmissionListWidget(assignment_id: widget.assignment.id),
              ],
            ),
          ),
        );
      },
    );
  }
}
