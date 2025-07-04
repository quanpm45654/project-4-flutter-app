import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/teacher/models/assignment.dart';
import 'package:project_4_flutter_app/teacher/pages/assignment/assignment_create_page.dart';
import 'package:project_4_flutter_app/teacher/pages/assignment/assignment_edit_page.dart';
import 'package:project_4_flutter_app/teacher/pages/assignment/assignment_page.dart';
import 'package:project_4_flutter_app/teacher/repositories/assignment_repository.dart';
import 'package:project_4_flutter_app/teacher/utils/functions.dart';
import 'package:provider/provider.dart';

class AssignmentListWidget extends StatefulWidget {
  const AssignmentListWidget({super.key, required this.class_id});

  final int class_id;

  @override
  State<AssignmentListWidget> createState() => _AssignmentListWidgetState();
}

class _AssignmentListWidgetState extends State<AssignmentListWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => Provider.of<AssignmentRepository>(
        context,
        listen: false,
      ).fetchAssignmentList(widget.class_id),
    );
  }

  Future<void> buildDialog(
    BuildContext context,
    AssignmentRepository assignmentRepository,
    Assignment assignment,
  ) async {
    return await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete confirmation'),
          content: const Text(
            'This assignment will be deleted forever',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await deleteAssignment(
                  assignmentRepository,
                  assignment,
                  context,
                );
              },
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll<Color>(
                  Colors.red.shade900,
                ),
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteAssignment(
    AssignmentRepository assignmentRepository,
    Assignment assignment,
    BuildContext context,
  ) async {
    await assignmentRepository.deleteAssignment(assignment.id);

    if (context.mounted) {
      if (assignmentRepository.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Assignment deleted successfully'),
            showCloseIcon: true,
          ),
        );
        Navigator.pop(context);
      } else if (assignmentRepository.errorMessageSnackBar.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(assignmentRepository.errorMessageSnackBar),
            showCloseIcon: true,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SizedBox(
            width: double.maxFinite,
            child: FilledButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => AssignmentCreatePage(class_id: widget.class_id),
                ),
              ),
              child: const Text('Create assignment'),
            ),
          ),
          const SizedBox(height: 16.0),
          Consumer<AssignmentRepository>(
            builder: (context, assignmentRepository, child) {
              List<Assignment> assignmentList = assignmentRepository.assignmentList;

              if (assignmentRepository.isLoading) {
                return const Flexible(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (assignmentRepository.errorMessage.isNotEmpty) {
                return Flexible(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          assignmentRepository.errorMessage,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 18.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        TextButton(
                          onPressed: () async =>
                              await assignmentRepository.fetchAssignmentList(widget.class_id),
                          child: const Text(
                            'Retry',
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              if (assignmentList.isEmpty) {
                return const Flexible(
                  child: Center(
                    child: Text(
                      "You haven't created any assignments in this class yet",
                      style: TextStyle(fontSize: 18.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              return Flexible(
                child: RefreshIndicator(
                  onRefresh: () async =>
                      await assignmentRepository.fetchAssignmentList(widget.class_id),
                  child: ListView.builder(
                    itemCount: assignmentList.length,
                    itemBuilder: (context, index) {
                      Assignment assignment = assignmentList[index];

                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (context) => AssignmentPage(assignment: assignment),
                          ),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const CircleAvatar(
                            child: Icon(Icons.assignment_outlined),
                          ),
                          title: Text(
                            assignment.title ?? '',
                            style: const TextStyle(fontSize: 18.0),
                          ),
                          subtitle: Text(
                            'Due ${CustomFormatter.formatDateTime(assignment.due_date)}',
                            style: DateTime.now().isAfter(assignment.due_date)
                                ? TextStyle(color: Colors.red.shade900)
                                : const TextStyle(),
                          ),
                          trailing: MenuAnchor(
                            builder: (context, controller, child) => IconButton(
                              onPressed: () =>
                                  controller.isOpen ? controller.close() : controller.open(),
                              icon: const Icon(Icons.more_vert_rounded),
                            ),
                            menuChildren: [
                              MenuItemButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (context) =>
                                        AssignmentEditPage(assignment: assignment),
                                  ),
                                ),
                                child: const Text('Edit'),
                              ),
                              MenuItemButton(
                                onPressed: () async =>
                                    buildDialog(context, assignmentRepository, assignment),
                                child: Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red.shade900),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
