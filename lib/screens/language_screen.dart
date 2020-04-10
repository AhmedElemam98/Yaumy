import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/app_language.dart';

class LanguageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<AppLanguage>(context);
    Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0XFFaa076b),
            Color(0XFF61045f)
            //Colors.green,
            //Colors.purple,
          ],
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Hero(
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
            orientation == Orientation.portrait
                ? SizedBox(
                    height: 150,
                  )
                : SizedBox(
                    height: 20,
                  ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RaisedButton(
                color: Color(0XFFaa076b),
                child: Container(
                    height: 50,
                    child: Center(
                        child: Text(
                      'عربي',
                      style: GoogleFonts.tajawal(
                          color: Colors.white, fontSize: 24),
                    ))),
                onPressed: () {
                  lang.setLanguage('arabic');
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RaisedButton(
                color: Color(0XFFaa076b),
                child: Container(
                    height: 50,
                    child: Center(
                        child: Text(
                      'english',
                      style:
                          GoogleFonts.ubuntu(color: Colors.white, fontSize: 24),
                    ))),
                onPressed: () {
                  lang.setLanguage('english');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


