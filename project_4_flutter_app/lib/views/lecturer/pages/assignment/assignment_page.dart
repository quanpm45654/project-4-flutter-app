import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/models/assignment.dart';
import 'package:project_4_flutter_app/repositories/assignment_repository.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/assignment/assignment_edit_page.dart';
import 'package:project_4_flutter_app/views/lecturer/widgets/assignment/assignment_widget.dart';
import 'package:project_4_flutter_app/views/lecturer/widgets/submission/submission_list_widget.dart';
import 'package:provider/provider.dart';

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
                  child: Text('Submission'),
                ),
              ],
            ),
            actions: [
              MenuAnchor(
                builder: (context, controller, child) {
                  return IconButton(
                    onPressed: () {
                      controller.isOpen ? controller.close() : controller.open();
                    },
                    icon: const Icon(Icons.more_vert_rounded),
                  );
                },
                menuChildren: [
                  MenuItemButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => AssignmentEditPage(assignment: assignmentRepository.assignmentList.firstWhere((a) => a.assignment_id == widget.assignment.assignment_id)),
                      ),
                    ),
                    child: const Text('Edit'),
                  ),
                ],
              ),
            ],
          ),
          body: SafeArea(
            child: TabBarView(
              controller: _tabController,
              children: [
                AssignmentWidget(assignment: assignmentRepository.assignmentList.firstWhere((a) => a.assignment_id == widget.assignment.assignment_id)),
                SubmissionListWidget(assignment_id: widget.assignment.assignment_id),
              ],
            ),
          ),
        );
      },
    );
  }
}
