import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utilities/constants.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: kBackgroundDecoration,
        child: Center(
          child: Hero(
            tag: 'logo',
            child: Material(
              color: Colors.transparent,
              child: Text(
                'Yaumy',
                style: GoogleFonts.permanentMarker(
                  color: Colors.white,
                  fontSize: 60,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
