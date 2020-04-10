import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './profile_screen.dart';
import './notification_screen.dart';
import './search_screen.dart';
import './timeline_screen.dart';
import './uploadpost_screen.dart';

class OverViewScreen extends StatefulWidget {
  @override
  _OverViewScreenState createState() => _OverViewScreenState();
}

class _OverViewScreenState extends State<OverViewScreen> {

  PageController _pageController;
  int _pageIndex = 0;

  @override
  void initState() {
    _pageController = PageController();

    super.initState();
  }
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onPageChanged(index){
    setState(() {
      _pageIndex=index;
    });
  }

  void onTap(int pageIndex) {
    _pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          TimelineScreen(),
          NotificationScreen(),
          UploadPostScreen(),
          SearchScreen(),
          ProfileScreen(),
        ],
        controller: _pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),

      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Color(0XFF61045f),
        activeColor: Colors.redAccent,
        inactiveColor: Colors.white,
        currentIndex: _pageIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.whatshot)),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_active)),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.photo_camera,
              //size: 35.0,
            ),
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search)),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle)),
        ],
        onTap:onTap,

      ),

    );
  }
}
