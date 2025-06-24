import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/home/home_page.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/class/class_list_page.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/assignment/assignment_list_page.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/profile/profile_page.dart';
import 'package:project_4_flutter_app/views/lecturer/states/lecturer_navigation_bar_state.dart';
import 'package:provider/provider.dart';

class LecturerNavigationBar extends StatelessWidget {
  const LecturerNavigationBar({super.key});

  static const List<Widget> _pageList = [
    HomePage(),
    ClassListPage(),
    AssignmentListPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final navigationBarState = Provider.of<LecturerNavigationBarState>(context);

    return NavigationBar(
      selectedIndex: navigationBarState.index,
      onDestinationSelected: (index) {
        navigationBarState.setIndex(index);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute<dynamic>(
            builder: (context) {
              return _pageList[index];
            },
          ),
          (Route<dynamic> route) {
            return false;
          },
        );
      },
      destinations: [
        const NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_rounded),
          label: 'Home',
        ),
        const NavigationDestination(
          icon: Icon(Icons.class_outlined),
          selectedIcon: Icon(Icons.class_rounded),
          label: 'Class',
        ),
        const NavigationDestination(
          icon: Icon(Icons.assignment_outlined),
          selectedIcon: Icon(Icons.assignment_rounded),
          label: 'Assignment',
        ),
        const NavigationDestination(
          icon: Icon(Icons.person_outlined),
          selectedIcon: Icon(Icons.person_rounded),
          label: 'Profile',
        ),
      ],
    );
  }
}
