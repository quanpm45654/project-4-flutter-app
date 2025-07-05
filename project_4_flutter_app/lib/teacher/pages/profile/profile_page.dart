import 'package:flutter/material.dart';

import '../../widgets/profile/profile_widget.dart';
import '../../widgets/teacher_navigation_bar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: const SafeArea(
        child: ProfileWidget(),
      ),
      bottomNavigationBar: const TeacherNavigationBar(),
    );
  }
}
