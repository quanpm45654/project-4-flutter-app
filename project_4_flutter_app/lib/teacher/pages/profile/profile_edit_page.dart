import 'package:flutter/material.dart';

import '../../models/teacher.dart';
import '../../widgets/profile/profile_edit_widget.dart';

class ProfileEditPage extends StatelessWidget {
  const ProfileEditPage({super.key, this.teacher});

  final Teacher? teacher;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Edit profile'),
      ),
      body: SafeArea(
        child: ProfileEditWidget(teacher: teacher),
      ),
    );
  }
}
