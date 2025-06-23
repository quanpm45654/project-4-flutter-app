import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/class/class_list_page.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/assignment/assignment_list_page.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/student/student_list_page.dart';
import 'package:project_4_flutter_app/views/lecturer/states/lecturer_navigation_bar_state.dart';
import 'package:provider/provider.dart';

class LecturerNavigationBar extends StatelessWidget {
  const LecturerNavigationBar({super.key});

  static const List<Widget> _pageList = [
    ClassListPage(),
    AssignmentListPage(),
    StudentListPage(),
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
          icon: Icon(Icons.class_outlined),
          label: 'Class',
        ),
        const NavigationDestination(
          icon: Icon(Icons.assignment_outlined),
          label: 'Assignment',
        ),
        const NavigationDestination(
          enabled: false,
          icon: Icon(Icons.person_outlined),
          label: 'Profile',
        ),
      ],
    );
  }
}
