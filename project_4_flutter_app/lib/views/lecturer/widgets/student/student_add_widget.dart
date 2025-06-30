import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/repositories/student_repository.dart';
import 'package:project_4_flutter_app/utils/validator.dart';
import 'package:provider/provider.dart';

class StudentAddWidget extends StatefulWidget {
  const StudentAddWidget({super.key, required this.class_id});

  final int class_id;

  @override
  State<StudentAddWidget> createState() => _StudentAddWidgetState();
}

class _StudentAddWidgetState extends State<StudentAddWidget> {
  final _formKey = GlobalKey<FormState>();
  final _studentEmail = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var studentRepository = Provider.of<StudentRepository>(context);

    return studentRepository.isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            spacing: 32.0,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: buildForm(),
                  ),
                ),
              ),
              Container(
                color: Theme.of(context).colorScheme.surfaceContainer,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  spacing: 16.0,
                  children: [
                    buildSubmitButton(context, studentRepository),
                    buildCancelButton(context),
                  ],
                ),
              ),
            ],
          );
  }

  Form buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        spacing: 16.0,
        children: [
          const SizedBox(),
          buildEmailField(),
        ],
      ),
    );
  }

  TextFormField buildEmailField() {
    return TextFormField(
      controller: _studentEmail,
      decoration: const InputDecoration(
        suffixIcon: Icon(Icons.mail_outline_rounded),
        border: OutlineInputBorder(),
        label: Text('Student email'),
      ),
      validator: (value) {
        return CustomValidator.combine([
          CustomValidator.required(value, 'Student email'),
          CustomValidator.email(value),
          CustomValidator.maxLength(value, 255),
        ]);
      },
    );
  }

  SizedBox buildSubmitButton(BuildContext context, StudentRepository studentRepository) {
    return SizedBox(
      width: double.maxFinite,
      height: 48.0,
      child: FilledButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            var class_id = widget.class_id;
            var email = _studentEmail.text;

            await studentRepository.addStudentToClass(
              class_id,
              email,
            );

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
                Navigator.pop(context);
              }
            }
          }
        },
        child: const Text('Add student'),
      ),
    );
  }

  SizedBox buildCancelButton(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: 48.0,
      child: TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
    );
  }
}
