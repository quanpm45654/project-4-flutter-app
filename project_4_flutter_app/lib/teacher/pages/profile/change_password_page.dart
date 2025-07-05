import 'package:flutter/material.dart';

import '../../widgets/profile/change_password_widget.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key, required this.teacher_id});

  final int teacher_id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Change password'),
      ),
      body: SafeArea(
        child: ChangePasswordWidget(teacher_id: teacher_id),
      ),
    );
  }
}
