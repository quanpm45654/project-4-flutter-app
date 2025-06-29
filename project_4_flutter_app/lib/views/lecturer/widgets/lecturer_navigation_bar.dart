import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/states/lecturer_navigation_bar_state.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/class/class_list_page.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/profile/profile_page.dart';
import 'package:provider/provider.dart';

class LecturerNavigationBar extends StatelessWidget {
  const LecturerNavigationBar({super.key});

  static const List<Widget> _pageList = [
    ClassListPage(),
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
          MaterialPageRoute<void>(
            builder: (context) => _pageList[index],
          ),
          (Route<dynamic> route) => false,
        );
      },
      destinations: [
        const NavigationDestination(
          icon: Icon(Icons.class_rounded),
          label: 'Class',
        ),
        const NavigationDestination(
          icon: Icon(Icons.person_rounded),
          label: 'Profile',
        ),
      ],
    );
  }
}
