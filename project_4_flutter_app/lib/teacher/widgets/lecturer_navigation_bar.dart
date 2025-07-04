import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/teacher/pages/class/class_list_page.dart';
import 'package:project_4_flutter_app/teacher/states/lecturer_navigation_bar_state.dart';
import 'package:provider/provider.dart';

class LecturerNavigationBar extends StatelessWidget {
  const LecturerNavigationBar({super.key});

  static const List<Widget> _pageList = [
    ClassListPage(),
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
          enabled: false,
        ),
      ],
    );
  }
}
