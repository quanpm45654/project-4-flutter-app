import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/teacher.dart';
import '../../pages/profile/change_password_page.dart';
import '../../pages/profile/profile_edit_page.dart';
import '../../repositories/teacher_repository.dart';
import '../../utils/shared_preference_service.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  int user_id = 0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    user_id = await SharedPreferenceService.getUserId() ?? 1001;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => Provider.of<TeacherRepository>(
        context,
        listen: false,
      ).fetchTeacher(user_id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Consumer<TeacherRepository>(
        builder: (context, teacherRepository, child) {
          Teacher? teacher = teacherRepository.teacher;

          if (teacherRepository.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (teacherRepository.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    teacherRepository.errorMessage,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 18.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16.0),
                  OutlinedButton.icon(
                    onPressed: () async => await teacherRepository.fetchTeacher(user_id),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text(
                      'Retry',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: CircleAvatar(
                  radius: 32.0,
                  child: Icon(Icons.person_rounded),
                ),
              ),
              const SizedBox(height: 16.0),
              Center(
                child: Text(
                  teacher?.full_name ?? '',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.mail_outline_rounded),
                  const SizedBox(width: 8.0),
                  Text(teacher?.email ?? ''),
                ],
              ),
              const SizedBox(height: 32.0),
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Edit profile'),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 20.0,
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => ProfileEditPage(teacher: teacher),
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.lock_outline_rounded),
                title: const Text('Change password'),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 20.0,
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => ChangePasswordPage(
                      teacher_id: teacher!.id,
                    ),
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text('Settings'),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 20.0,
                ),
                onTap: () {},
              ),
            ],
          );
        },
      ),
    );
  }
}
