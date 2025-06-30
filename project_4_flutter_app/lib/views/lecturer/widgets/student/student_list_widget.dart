import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/models/student.dart';
import 'package:project_4_flutter_app/repositories/student_repository.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/student/student_add_page.dart';
import 'package:provider/provider.dart';

class StudentListWidget extends StatefulWidget {
  const StudentListWidget({super.key, required this.class_id});

  final int class_id;

  @override
  State<StudentListWidget> createState() => _StudentListWidgetState();
}

class _StudentListWidgetState extends State<StudentListWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => Provider.of<StudentRepository>(
        context,
        listen: false,
      ).fetchClassStudentList(widget.class_id),
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
          buildAddButton(context),
          const SizedBox(height: 16.0),
          buildConsumer(),
        ],
      ),
    );
  }

  SizedBox buildAddButton(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: 48.0,
      child: FilledButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) => StudentAddPage(class_id: widget.class_id),
          ),
        ),
        child: const Text('Add student'),
      ),
    );
  }

  Consumer<StudentRepository> buildConsumer() {
    return Consumer<StudentRepository>(
      builder: (context, studentRepository, child) {
        var studentList = studentRepository.studentList;

        if (studentRepository.isLoading) {
          return const Flexible(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (studentRepository.errorMessage.isNotEmpty) {
          return buildErrorMessage(studentRepository, context);
        }

        if (studentList.isEmpty) {
          return const Flexible(
            child: Center(
              child: Text(
                "You haven't added any students to this class yet",
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return Flexible(
          child: RefreshIndicator(
            onRefresh: () async =>
                await studentRepository.fetchClassStudentList(widget.class_id),
            child: buildStudentListView(studentList, studentRepository),
          ),
        );
      },
    );
  }

  Flexible buildErrorMessage(
    StudentRepository studentRepository,
    BuildContext context,
  ) {
    return Flexible(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              studentRepository.errorMessage,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
              textAlign: TextAlign.center,
            ),
            TextButton(
              onPressed: () async => await studentRepository
                  .fetchClassStudentList(widget.class_id),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  ListView buildStudentListView(
    List<Student> studentList,
    StudentRepository studentRepository,
  ) {
    return ListView.builder(
      itemCount: studentList.length,
      itemBuilder: (context, index) {
        var student = studentList[index];

        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: const Icon(Icons.person_outline_rounded),
          ),
          title: Text(
            student.full_name,
            style: const TextStyle(fontSize: 20.0),
          ),
          subtitle: Text(student.email),
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
              buildMenuRemoveButton(context, studentRepository, student),
            ],
          ),
        );
      },
    );
  }

  MenuItemButton buildMenuRemoveButton(
    BuildContext context,
    StudentRepository studentRepository,
    Student student,
  ) {
    return MenuItemButton(
      onPressed: () async =>
          await buildRemoveDialog(context, studentRepository, student),
      child: Text(
        'Remove from class',
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
    );
  }

  Future<void> buildRemoveDialog(
    BuildContext context,
    StudentRepository studentRepository,
    Student student,
  ) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove confirmation'),
          content: const Text('This student will be removed from class'),
          actions: [
            buildCancelButton(context),
            buildDeleteButton(studentRepository, student, context),
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
    StudentRepository studentRepository,
    Student student,
    BuildContext context,
  ) {
    return TextButton(
      onPressed: () async {
        var class_id = widget.class_id;
        var student_id = student.user_id;

        await studentRepository.removeStudentFromClass(
          class_id,
          student_id,
        );

        if (context.mounted) {
          if (studentRepository.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Student removed successfully'),
                showCloseIcon: true,
              ),
            );
            Navigator.pop(context);
          } else if (studentRepository.errorMessageSnackBar.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(studentRepository.errorMessageSnackBar),
                showCloseIcon: true,
              ),
            );
            Navigator.pop(context);
          }
        }
      },
      child: Text(
        'Remove',
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
    );
  }
}
