import 'package:flutter/material.dart';
import 'package:kisan_app/src/ui/views/admin/adminProfile.dart';
import 'package:kisan_app/src/ui/views/admin/appUserList.dart';

class AdminHomeScreen extends StatefulWidget {
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _currentNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: _currentNavIndex,
      children: [
        AppUserListScreen(adminNavBar: adminNavigationBar),
        AdminProfileScreen(adminNavBar: adminNavigationBar),
      ],
    );
  }

  BottomNavigationBar adminNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentNavIndex,
      fixedColor: Colors.white,
      unselectedItemColor: Colors.white60,
      backgroundColor: Colors.lightGreen[800],
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_rounded),
          label: 'Profile',
        ),
      ],
      onTap: (index) {
        setState(() {
          _currentNavIndex = index;
        });
      },
    );
  }
}
