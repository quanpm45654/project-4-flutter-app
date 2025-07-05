import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/teacher.dart';
import '../../repositories/teacher_repository.dart';
import '../../utils/validator.dart';

class ProfileEditWidget extends StatefulWidget {
  const ProfileEditWidget({super.key, this.teacher});

  final Teacher? teacher;

  @override
  State<ProfileEditWidget> createState() => _ProfileEditWidget();
}

class _ProfileEditWidget extends State<ProfileEditWidget> {
  final _formKey = GlobalKey<FormState>();
  final _fullName = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fullName.text = widget.teacher?.full_name ?? '';
  }

  Future<void> editProfile(TeacherRepository teacherRepository, BuildContext context) async {
    int id = widget.teacher?.id ?? 0;
    String full_name = _fullName.text;
    Teacher teacher = Teacher(id, full_name, '');

    await teacherRepository.editProfile(teacher);
    await teacherRepository.fetchTeacher(id);

    if (context.mounted) {
      if (teacherRepository.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile edited successfully'),
            showCloseIcon: true,
          ),
        );
        Navigator.pop(context);
      } else if (teacherRepository.errorMessageSnackBar.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(teacherRepository.errorMessageSnackBar),
            showCloseIcon: true,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final teacherRepository = Provider.of<TeacherRepository>(context);

    return teacherRepository.isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
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
                            controller: _fullName,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text('Full name'),
                            ),
                            validator: (value) => CustomValidator.combine([
                              CustomValidator.required(value, 'Full name'),
                              CustomValidator.maxLength(value, 100),
                            ]),
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
                            editProfile(teacherRepository, context);
                          }
                        },
                        child: const Text('Edit profile'),
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
