import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yaumyapp/providers/posts.dart';
import 'package:yaumyapp/screens/language_screen.dart';
import './screens/login_screen.dart';
import './providers/auth.dart';
import 'package:provider/provider.dart';
import './providers/user.dart';
import './providers/app_language.dart';
import './screens/language_screen.dart';
import './screens/splash_screen.dart';
import './widgets/is_overview.dart';

void main() => runApp(
      MyApp(),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider.value(value: AppLanguage()),
        ChangeNotifierProxyProvider<Auth, User>(
          //This only will rebuild when Auth is changed
          create: (ctx) => User(Auth().userId, null),
          update: (ctx, auth, previousUser) => User(auth.userId,
              previousUser == null ? null : previousUser.currentUser),
        ),
        ChangeNotifierProxyProvider<Auth, Posts>(
          //This only will rebuild when Auth is changed
          create: (ctx) => Posts(Auth().userId, null),
          update: (ctx, auth, previousPosts) => Posts(
              auth.userId, previousPosts == null ? [] : previousPosts.posts),
        ),
      ],
      child: MaterialApp(
        title: "Yaumy",
        debugShowCheckedModeBanner: false,
        home: Home(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    final lang = Provider.of<AppLanguage>(context);
    if (lang.isChoseLanguage) {
      return auth.isAuth
          ? IsOverview()
          : FutureBuilder(
              future: auth.reAuth(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (auth.isAuth) {
                    return IsOverview();
                  } else {
                    return LoginScreen();
                  }
                } else {
                  return SplashScreen();
                }
              });
    } else {
      return FutureBuilder(
        future: lang.reGetLanguage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (!lang.isChoseLanguage) return LanguageScreen();
             return Home();
          } else {
            return SplashScreen();
          }
        },
      );
    }
  }
}
/*
FutureBuilder(
        future: auth.reAuth(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (auth.isAuth) {
              return ProfileScreen();
            } else {
              return LoginScreen();
            }
          } else {
            return LoadingScreen();
          }
        });
 */

/*
FutureBuilder(
                  future: auth.reAuth(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (auth.isAuth) {
                        return ProfileScreen();
                      } else {
                        return LoginScreen();
                      }
                    } else {
                      return LoadingScreen();
                    }
                  }),
 */
