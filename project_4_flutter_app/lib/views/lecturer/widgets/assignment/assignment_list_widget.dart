import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/models/assignment.dart';
import 'package:project_4_flutter_app/repositories/assignment_repository.dart';
import 'package:project_4_flutter_app/utils/functions.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/assignment/assignment_create_page.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/assignment/assignment_edit_page.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/assignment/assignment_page.dart';
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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          buildCreateButton(context),
          const SizedBox(height: 16.0),
          buildConsumer(),
        ],
      ),
    );
  }

  SizedBox buildCreateButton(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: FilledButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) =>
                AssignmentCreatePage(class_id: widget.class_id),
          ),
        ),
        child: const Text('Create assignment'),
      ),
    );
  }

  Consumer<AssignmentRepository> buildConsumer() {
    return Consumer<AssignmentRepository>(
      builder: (context, assignmentRepository, child) {
        var assignmentList = assignmentRepository.assignmentList;

        if (assignmentRepository.isLoading) {
          return const Flexible(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (assignmentRepository.errorMessage.isNotEmpty) {
          return buildErrorMessage(assignmentRepository, context);
        }

        if (assignmentList.isEmpty) {
          return const Flexible(
            child: Center(
              child: Text(
                "You haven't created any assignments in this class yet",
                style: TextStyle(fontSize: 20.0),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return Flexible(
          child: RefreshIndicator(
            onRefresh: () async =>
                await assignmentRepository.fetchAssignmentList(widget.class_id),
            child: buildAssignmentListView(
              assignmentRepository,
              assignmentList,
            ),
          ),
        );
      },
    );
  }

  Flexible buildErrorMessage(
    AssignmentRepository assignmentRepository,
    BuildContext context,
  ) {
    return Flexible(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              assignmentRepository.errorMessage,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
            ),
            TextButton(
              onPressed: () async => await assignmentRepository
                  .fetchAssignmentList(widget.class_id),
              child: const Text(
                'Retry',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListView buildAssignmentListView(
    AssignmentRepository assignmentRepository,
    List<Assignment> assignmentList,
  ) {
    return ListView.builder(
      itemCount: assignmentList.length,
      itemBuilder: (context, index) {
        var assignment = assignmentList[index];

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
              assignment.title,
              style: const TextStyle(fontSize: 20.0),
            ),
            subtitle: Text(
              'Due ${CustomFormatter.formatDateTime(assignment.due_at)}',
              style: DateTime.now().isAfter(assignment.due_at)
                  ? TextStyle(color: Colors.red.shade900)
                  : const TextStyle(),
            ),
            trailing: MenuAnchor(
              builder: (context, controller, child) {
                return IconButton(
                  onPressed: () {
                    controller.isOpen ? controller.close() : controller.open();
                  },
                  icon: const Icon(Icons.more_vert_rounded),
                );
              },
              menuChildren: [
                buildMenuEditButton(context, assignment),
                buildMenuDeleteButton(
                  context,
                  assignmentRepository,
                  assignment,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  MenuItemButton buildMenuEditButton(
    BuildContext context,
    Assignment assignment,
  ) {
    return MenuItemButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (context) => AssignmentEditPage(assignment: assignment),
        ),
      ),
      child: const Text('Edit'),
    );
  }

  MenuItemButton buildMenuDeleteButton(
    BuildContext context,
    AssignmentRepository assignmentRepository,
    Assignment assignment,
  ) {
    return MenuItemButton(
      onPressed: () async =>
          await buildDeleteDialog(context, assignmentRepository, assignment),
      child: Text(
        'Delete',
        style: TextStyle(color: Colors.red.shade900),
      ),
    );
  }

  Future<void> buildDeleteDialog(
    BuildContext context,
    AssignmentRepository assignmentRepository,
    Assignment assignment,
  ) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete confirmation'),
          content: const Text('This assignment will be deleted forever'),
          actions: [
            buildCancelButton(context),
            buildDeleteButton(assignmentRepository, assignment, context),
          ],
        );
      },
    );
  }

  TextButton buildCancelButton(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: const Text('Cancel'),
    );
  }

  TextButton buildDeleteButton(
    AssignmentRepository assignmentRepository,
    Assignment assignment,
    BuildContext context,
  ) {
    return TextButton(
      onPressed: () async {
        await assignmentRepository.deleteAssignment(assignment.assignment_id);

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
      },
      child: Text(
        'Delete',
        style: TextStyle(color: Colors.red.shade900),
      ),
    );
  }
}
