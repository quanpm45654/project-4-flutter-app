import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/views/lecturer/widgets/lecturer_navigation_bar.dart';
import 'package:project_4_flutter_app/views/lecturer/widgets/profile/profile_widget.dart';

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
      bottomNavigationBar: const LecturerNavigationBar(),
    );
  }
}
