import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Auth with ChangeNotifier {
  String _userId;
  bool _isAuth = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final facebookLogin = FacebookLogin();
  final usersRef = Firestore.instance.collection('users');

  String get userId {
    return _userId;
  }

  bool get isAuth {
    return _isAuth;
  }

  Future<bool> reAuth() async {
    final FirebaseUser currentUser = await _auth.currentUser();
    _isAuth = (currentUser != null);
    if (_isAuth == false) {
      return false;
    }
    _userId = currentUser.uid;
    _isAuth = true;
    notifyListeners();
    return true;
  }

  void logout() async {
    try {
      _auth.signOut();
      _googleSignIn.signOut();
      facebookLogin.logOut();

      _isAuth = false;
      _userId = null;
      notifyListeners();
    } catch (e) {
      throw Exception(e);
    }
  }

  signUpUsingPassword({String email, String password, String username}) async {
    try {
      var result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      FirebaseUser currentUser = result.user;

      await signUserInFireStore(
        username: username,
        email: currentUser.email,
        displayName: currentUser.displayName,
        id: currentUser.uid,
        photoUrl: currentUser.photoUrl,
      );

      _userId = currentUser.uid;
      _isAuth = true;
      notifyListeners();
    } catch (e) {
      throw Exception(e.message);
    }
  }

  loginUsingPassword({String email, String password}) async {
    try {
      var result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      FirebaseUser currentUser = result.user;

      _isAuth = true;
      _userId = currentUser.uid;
      notifyListeners();
    } catch (e) {
      throw Exception(e.message);
    }
  }

  void signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)).user;
      assert(user.email != null);
      assert(user.displayName != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);

      await signUserInFireStore(
        email: currentUser.email,
        displayName: currentUser.displayName,
        id: currentUser.uid,
        photoUrl: currentUser.photoUrl,
      );
      _userId = currentUser.uid;
      _isAuth = true;
      notifyListeners();
    } catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> signUserInFireStore({
    String username,
    String id,
    String photoUrl,
    String email,
    String displayName,
    String registeredTime,
  }) async {
    final _user = await usersRef.document(id).get();
    if (!_user.exists) {
      try{
        await usersRef.document(id).setData({
          "id": id,
          "username": username,
          "photourl": photoUrl,
          "email": email,
          "displayname": displayName,
          "bio": "",
          "registered_time":Timestamp.now(),
        });
      }
      catch (e) {
        throw Exception(e.message);
      }

    }
  }

  void signInWithFacebook() async {
    try {
      final result = await facebookLogin.logIn(['email']);
      final FacebookAccessToken accessToken = result.accessToken;
      final AuthCredential credential = FacebookAuthProvider.getCredential(
        accessToken: accessToken.token,
      );
      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)).user;
      assert(user.email != null);
      assert(user.displayName != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);

      await signUserInFireStore(
        email: currentUser.email,
        displayName: currentUser.displayName,
        id: currentUser.uid,
        photoUrl: currentUser.photoUrl,
      );
      _userId = currentUser.uid;
      _isAuth = true;
      notifyListeners();
    } catch (e) {
      throw Exception(e.message);
    }
  }

}
