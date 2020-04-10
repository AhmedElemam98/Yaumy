import 'package:flutter/material.dart';
import '../providers/auth.dart';
import '../providers/user.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final auth = Provider.of<Auth>(context);
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
        child: InkWell(
          child: Text(user.currentUser.id),
          onTap: () => auth.logout(),
        ),
      ),
    ));
  }
}
