import 'package:flutter/material.dart';
import 'package:kisan_app/src/ui/views/shared/appUserProfile.dart';
import 'package:kisan_app/src/ui/views/shared/articleList.dart';
import 'package:kisan_app/src/ui/views/shared/newsList.dart';
import 'package:kisan_app/src/ui/views/shared/schemeList.dart';
import 'package:kisan_app/src/ui/widgets/styles.dart';
import 'farmerChatList.dart';

class AgriExpertHomeScreen extends StatefulWidget {
  @override
  _AgriExpertHomeScreenState createState() => _AgriExpertHomeScreenState();
}

class _AgriExpertHomeScreenState extends State<AgriExpertHomeScreen> {
  int _currentNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(context),
      body: IndexedStack(
        index: _currentNavIndex,
        children: [
          NewsListScreen(),
          SchemeListScreen(),
          FarmerChatListScreen(),
          ArticleListScreen(),
          AppUserProfileScreen(),
        ],
      ),
      bottomNavigationBar: agriExpertNavigationBar(),
    );
  }

  BottomNavigationBar agriExpertNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentNavIndex,
      fixedColor: Colors.white,
      unselectedItemColor: Colors.white70,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.public),
          label: 'News',
          backgroundColor: Colors.lightGreen[800],
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.widgets),
          label: 'Schemes',
          backgroundColor: Colors.lightGreen[800],
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          label: 'Chat',
          backgroundColor: Colors.lightGreen[800],
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.article),
          label: 'Articles',
          backgroundColor: Colors.lightGreen[800],
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_rounded),
          label: 'Profile',
          backgroundColor: Colors.lightGreen[800],
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
