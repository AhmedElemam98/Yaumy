import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../providers/user.dart';
import '../providers/auth.dart';
import '../screens/username_screen.dart';
import '../screens/overview_screen.dart';
class IsOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final auth = Provider.of<Auth>(context);
    return Scaffold(
      body: StreamBuilder(
        stream: user.fetchCurrentUser().asStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (user.currentUser != null) {
              if (user.currentUser.userName != null) {
                return OverViewScreen();
              } else {
                return UserNameScreen();
              }
            } else {
              auth.logout();
              return Home();
            }
          } else {
            return Scaffold(
              body: Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Color(0XFFaa076b), Color(0XFF61045f)],
                    ),
                  ),
                  child: Center(
                      child: SpinKitFadingGrid(
                          color: Colors.white, shape: BoxShape.rectangle))),
            );
          }
        },
      ),
    );
  }
}
