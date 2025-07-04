import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/teacher/models/student.dart';
import 'package:project_4_flutter_app/teacher/pages/student/student_add_page.dart';
import 'package:project_4_flutter_app/teacher/repositories/student_repository.dart';
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

  Future<void> buildDialog(
    BuildContext context,
    StudentRepository studentRepository,
    Student student,
  ) async {
    return await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove confirmation'),
          content: const Text('This student will be removed from class'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async => removeStudent,
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll<Color>(
                  Colors.red.shade900,
                ),
              ),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  Future<void> removeStudent(
    Student student,
    StudentRepository studentRepository,
    BuildContext context,
  ) async {
    int class_id = widget.class_id;
    int student_id = student.id;

    await studentRepository.removeStudentFromClass(class_id, student_id);

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
                  builder: (context) => StudentAddPage(class_id: widget.class_id),
                ),
              ),
              child: const Text('Add student'),
            ),
          ),
          const SizedBox(height: 16.0),
          Consumer<StudentRepository>(
            builder: (context, studentRepository, child) {
              List<Student> studentList = studentRepository.studentList;

              if (studentRepository.isLoading) {
                return const Flexible(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (studentRepository.errorMessage.isNotEmpty) {
                return Flexible(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          studentRepository.errorMessage,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 18.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        TextButton(
                          onPressed: () async =>
                              await studentRepository.fetchClassStudentList(widget.class_id),
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
              if (studentList.isEmpty) {
                return const Flexible(
                  child: Center(
                    child: Text(
                      "You haven't added any students to this class yet",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                );
              }

              return Flexible(
                child: RefreshIndicator(
                  onRefresh: () async =>
                      await studentRepository.fetchClassStudentList(widget.class_id),
                  child: ListView.builder(
                    itemCount: studentList.length,
                    itemBuilder: (context, index) {
                      var student = studentList[index];

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const CircleAvatar(
                          child: Icon(Icons.person_outline_rounded),
                        ),
                        title: Text(
                          student.full_name ?? '',
                          style: const TextStyle(fontSize: 18.0),
                        ),
                        subtitle: Text(student.email ?? ''),
                        trailing: MenuAnchor(
                          builder: (context, controller, child) => IconButton(
                            onPressed: () =>
                                controller.isOpen ? controller.close() : controller.open(),
                            icon: const Icon(Icons.more_vert_rounded),
                          ),
                          menuChildren: [
                            MenuItemButton(
                              onPressed: () async => buildDialog,
                              child: Text(
                                'Remove from class',
                                style: TextStyle(color: Colors.red.shade900),
                              ),
                            ),
                          ],
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
