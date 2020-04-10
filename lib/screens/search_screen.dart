import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utilities/constants.dart';
import '../providers/posts.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final posts = Provider.of<Posts>(context);
    return Scaffold(
        body: Container(
      height: double.infinity,
      width: double.infinity,
      decoration: kBackgroundDecoration,
    ));
  }
}
