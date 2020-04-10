import 'package:flutter/material.dart';
import '../providers/auth.dart';
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(child: Text('logged in'),onTap: (){
         // Auth().reAuth();
          Auth().logout();
          Auth().reAuth();

        },),
      ),
    );
  }
}
