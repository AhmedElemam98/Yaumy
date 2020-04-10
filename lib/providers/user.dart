import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/UserData.dart';

class User with ChangeNotifier {
  final String _userId;
  final usersRef = Firestore.instance.collection('users');
  UserData _currentUser;

  User(this._userId, this._currentUser);

  get currentUser {
    return _currentUser;
  }
  get userId{
    return _userId;
  }

  Future<void> fetchCurrentUser() async {
    try{
      final _user = await usersRef.document(_userId).get();
      _currentUser = UserData(
          id: _user['id'],
          userName: _user['username'],
          photoUrl: _user['photourl'],
          email: _user['email'],
          displayName: _user['displayName'],
          bio: _user['bio']);
    }
    catch (e) {
      print(e);
      // throw Exception(e.message);
    }
  }

  Future<void>updateUserName(String username)async{
    try{
      await usersRef.document(_userId).updateData(
          {'username':username}
      );
      notifyListeners();
    }
    catch (e) {
      throw Exception(e.message);
    }

  }

}
