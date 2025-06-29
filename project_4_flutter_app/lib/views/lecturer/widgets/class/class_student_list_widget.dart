import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/repositories/student_repository.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/student/student_add_page.dart';
import 'package:provider/provider.dart';

class ClassStudentListWidget extends StatefulWidget {
  const ClassStudentListWidget({super.key, required this.class_id});

  final num class_id;

  @override
  State<ClassStudentListWidget> createState() => _ClassStudentListWidgetState();
}

class _ClassStudentListWidgetState extends State<ClassStudentListWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => Provider.of<StudentRepository>(
        context,
        listen: false,
      ).fetchClassStudentList(class_id: widget.class_id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildAddButton(context),
        const SizedBox(height: 16),
        buildConsumer(),
      ],
    );
  }

  SizedBox buildAddButton(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: 48,
      child: FilledButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) => const StudentAddPage(),
          ),
        ),
        child: const Text(
          'Add student',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }

  Consumer<StudentRepository> buildConsumer() {
    return Consumer<StudentRepository>(
      builder: (context, studentRepository, child) {
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

        if (studentRepository.studentList.isEmpty) {
          return const Flexible(
            child: Center(
              child: Text(
                "You haven't added any students to this class yet",
                style: TextStyle(fontSize: 20.0),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return Flexible(
          child: buildStudentListView(studentRepository),
        );
      },
    );
  }

  Flexible buildErrorMessage(StudentRepository studentRepository, BuildContext context) {
    return Flexible(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              studentRepository.errorMessage,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
            ),
            TextButton(
              onPressed: () => Provider.of<StudentRepository>(
                context,
                listen: false,
              ).fetchClassStudentList(class_id: widget.class_id),
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

  ListView buildStudentListView(StudentRepository studentRepository) {
    return ListView.builder(
      itemCount: studentRepository.studentList.length,
      itemBuilder: (context, index) {
        var student = studentRepository.studentList[index];

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
          subtitle: Text(
            student.email,
            style: const TextStyle(fontSize: 16.0),
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
              MenuItemButton(
                onPressed: () {},
                child: const Text(
                  'Remove student from class',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
