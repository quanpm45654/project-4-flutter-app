import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../repositories/teacher_repository.dart';
import '../../utils/validator.dart';

class ChangePasswordWidget extends StatefulWidget {
  const ChangePasswordWidget({super.key, required this.teacher_id});

  final int teacher_id;

  @override
  State<ChangePasswordWidget> createState() => _ChangePasswordWidgetState();
}

class _ChangePasswordWidgetState extends State<ChangePasswordWidget> {
  final _formKey = GlobalKey<FormState>();
  final _oldPassword = TextEditingController();
  final _newPassword = TextEditingController();
  bool _isOldPasswordObscured = true;
  bool _isNewPasswordObscured = true;

  Future<void> changePassword(TeacherRepository teacherRepository, BuildContext context) async {
    int id = widget.teacher_id;
    String oldPassword = _oldPassword.text;
    String newPassword = _newPassword.text;

    await teacherRepository.changePassword(oldPassword, newPassword, id);

    if (context.mounted) {
      if (teacherRepository.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password changed successfully'),
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
                          TextFormField(
                            controller: _oldPassword,
                            obscureText: _isOldPasswordObscured,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              label: const Text('Old password'),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isOldPasswordObscured
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                                onPressed: () => setState(
                                  () => _isOldPasswordObscured = !_isOldPasswordObscured,
                                ),
                              ),
                            ),
                            validator: (value) => CustomValidator.combine([
                              CustomValidator.required(value, 'Old password'),
                              CustomValidator.maxLength(value, 255),
                            ]),
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: _newPassword,
                            obscureText: _isNewPasswordObscured,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              label: const Text('New password'),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isNewPasswordObscured
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                                onPressed: () => setState(
                                  () => _isNewPasswordObscured = !_isNewPasswordObscured,
                                ),
                              ),
                            ),
                            validator: (value) => CustomValidator.combine([
                              CustomValidator.required(value, 'New password'),
                              CustomValidator.maxLength(value, 255),
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
                            changePassword(teacherRepository, context);
                          }
                        },
                        child: const Text('Change password'),
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
