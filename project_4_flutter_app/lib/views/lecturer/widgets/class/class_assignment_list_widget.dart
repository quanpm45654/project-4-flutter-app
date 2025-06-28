import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/models/assignment.dart';
import 'package:project_4_flutter_app/repositories/assignment_repository.dart';
import 'package:project_4_flutter_app/utils/functions.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/assignment/assignment_create_page.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/assignment/assignment_edit_page.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/assignment/assignment_page.dart';
import 'package:provider/provider.dart';

class ClassAssignmentListWidget extends StatefulWidget {
  const ClassAssignmentListWidget({super.key, required this.class_id});

  final num class_id;

  @override
  State<ClassAssignmentListWidget> createState() => _ClassAssignmentListWidgetState();
}

class _ClassAssignmentListWidgetState extends State<ClassAssignmentListWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => Provider.of<AssignmentRepository>(
        context,
        listen: false,
      ).fetchClassAssignmentList(class_id: widget.class_id, lecturer_id: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildCreateButton(context),
        const SizedBox(height: 16),
        buildConsumer(),
      ],
    );
  }

  Consumer<AssignmentRepository> buildConsumer() {
    return Consumer<AssignmentRepository>(
      builder: (context, assignmentRepository, child) {
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

        if (assignmentRepository.assignmentList.isEmpty) {
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

        final assignmentList = assignmentRepository.assignmentList;
        assignmentList.sort((a, b) => b.assignment_id.compareTo(a.assignment_id));

        return Flexible(
          child: buildListView(assignmentRepository, assignmentList),
        );
      },
    );
  }

  ListView buildListView(
    AssignmentRepository assignmentRepository,
    List<Assignment> assignmentList,
  ) {
    return ListView.builder(
      itemCount: assignmentRepository.assignmentList.length,
      itemBuilder: (context, index) {
        final assignment = assignmentList[index];

        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => AssignmentPage(assignment: assignment),
            ),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: const Icon(Icons.assignment_outlined),
            ),
            title: Text(
              assignment.title,
              style: const TextStyle(fontSize: 20.0),
            ),
            subtitle: Text(
              'Due ${CustomFormatter.formatDateTime(assignment.due_at)}',
              style: DateTime.now().isAfter(assignment.due_at)
                  ? TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 16.0)
                  : const TextStyle(fontSize: 16.0),
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
                buildMenuDeleteButton(context, assignmentRepository, assignment),
              ],
            ),
          ),
        );
      },
    );
  }

  SizedBox buildCreateButton(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: 48,
      child: FilledButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) => AssignmentCreatePage(class_id: widget.class_id),
          ),
        ),
        child: const Text(
          'Create assignment',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }

  Flexible buildErrorMessage(AssignmentRepository assignmentRepository, BuildContext context) {
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
              onPressed: () => Provider.of<AssignmentRepository>(
                context,
                listen: false,
              ).fetchClassAssignmentList(class_id: widget.class_id, lecturer_id: 2),
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

  MenuItemButton buildMenuEditButton(BuildContext context, Assignment assignment) {
    return MenuItemButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (context) => AssignmentEditPage(assignment: assignment),
        ),
      ),
      child: const Text(
        'Edit',
        style: TextStyle(fontSize: 16.0),
      ),
    );
  }

  MenuItemButton buildMenuDeleteButton(
    BuildContext context,
    AssignmentRepository assignmentRepository,
    Assignment assignment,
  ) {
    return MenuItemButton(
      onPressed: () async => await buildDeleteDialog(context, assignmentRepository, assignment),
      child: Text(
        'Delete',
        style: TextStyle(
          color: Theme.of(context).colorScheme.error,
          fontSize: 16.0,
        ),
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
          content: const Text(
            'This assignment will be deleted forever',
            style: TextStyle(fontSize: 16.0),
          ),
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
      child: const Text(
        'Cancel',
        style: TextStyle(fontSize: 16.0),
      ),
    );
  }

  TextButton buildDeleteButton(
    AssignmentRepository assignmentRepository,
    Assignment assignment,
    BuildContext context,
  ) {
    return TextButton(
      onPressed: () async {
        await assignmentRepository.deleteAssignment(
          assignment_id: assignment.assignment_id,
        );
        if (context.mounted) {
          if (assignmentRepository.errorMessageSnackBar.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Assignment deleted successfully',
                  style: TextStyle(fontSize: 16.0),
                ),
                showCloseIcon: true,
              ),
            );
            Navigator.pop(context);
          } else if (assignmentRepository.errorMessageSnackBar.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  assignmentRepository.errorMessageSnackBar,
                  style: const TextStyle(fontSize: 16.0),
                ),
                showCloseIcon: true,
              ),
            );
            Navigator.pop(context);
          }
        }
      },
      child: Text(
        'Delete',
        style: TextStyle(
          color: Theme.of(context).colorScheme.error,
          fontSize: 16.0,
        ),
      ),
    );
  }
}
