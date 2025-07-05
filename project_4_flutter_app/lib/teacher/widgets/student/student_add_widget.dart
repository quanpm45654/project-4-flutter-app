import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../repositories/student_repository.dart';
import '../../utils/validator.dart';

class StudentAddWidget extends StatefulWidget {
  const StudentAddWidget({super.key, required this.class_id});

  final int class_id;

  @override
  State<StudentAddWidget> createState() => _StudentAddWidgetState();
}

class _StudentAddWidgetState extends State<StudentAddWidget> {
  final _formKey = GlobalKey<FormState>();
  final _studentEmail = TextEditingController();

  Future<void> addStudent(
    StudentRepository studentRepository,
    BuildContext context,
  ) async {
    int class_id = widget.class_id;
    String email = _studentEmail.text;

    await studentRepository.addStudentToClass(class_id, email);

    if (context.mounted) {
      if (studentRepository.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Student added successfully'),
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
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final studentRepository = Provider.of<StudentRepository>(context);

    return studentRepository.isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            spacing: 32.0,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: _studentEmail,
                            decoration: const InputDecoration(
                              suffixIcon: Icon(Icons.mail_outline_rounded),
                              border: OutlineInputBorder(),
                              label: Text('Student email'),
                            ),
                            validator: (value) {
                              var result = CustomValidator.combine([
                                CustomValidator.required(
                                  value,
                                  'Student email',
                                ),
                                CustomValidator.email(value),
                                CustomValidator.maxLength(value, 100),
                              ]);
                              String? result2;
                              if (studentRepository.studentList.any(
                                (a) => a.email == value,
                              )) {
                                result2 = 'This student has already been added to this class';
                              }
                              return result ?? result2;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                color: Theme.of(context).colorScheme.surfaceContainer,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  spacing: 16.0,
                  children: [
                    SizedBox(
                      width: double.maxFinite,
                      child: FilledButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            addStudent(studentRepository, context);
                          }
                        },
                        child: const Text('Add student'),
                      ),
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}
