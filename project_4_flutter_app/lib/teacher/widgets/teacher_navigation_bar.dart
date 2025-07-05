import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/class/class_list_page.dart';
import '../pages/profile/profile_page.dart';
import '../states/teacher_navigation_bar_state.dart';

class TeacherNavigationBar extends StatelessWidget {
  const TeacherNavigationBar({super.key});

  static const List<Widget> _pageList = [
    ClassListPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final navigationBarState = Provider.of<TeacherNavigationBarState>(context);

    return NavigationBar(
      selectedIndex: navigationBarState.index,
      onDestinationSelected: (index) {
        navigationBarState.setIndex(index);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute<void>(
            builder: (context) => _pageList[index],
          ),
          (Route<dynamic> route) => false,
        );
      },
      destinations: [
        const NavigationDestination(
          icon: Icon(Icons.class_outlined),
          selectedIcon: Icon(Icons.class_rounded),
          label: 'Class',
        ),
        const NavigationDestination(
          icon: Icon(Icons.person_outline_rounded),
          selectedIcon: Icon(Icons.person_rounded),
          label: 'Profile',
        ),
      ],
    );
  }
}
