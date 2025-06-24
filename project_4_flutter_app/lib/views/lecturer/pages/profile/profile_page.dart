import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/utils/constants.dart';
import 'package:project_4_flutter_app/views/lecturer/widgets/lecturer_navigation_bar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(CustomSize.medium),
          child: const Text('Under construction'),
        ),
      ),
      bottomNavigationBar: const LecturerNavigationBar(),
    );
  }
}
