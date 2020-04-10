import 'package:flutter/foundation.dart';
class UserData {
  final String id;
  final String userName;
  final String photoUrl;
  final String email;
  final String displayName;
  final String bio;

  UserData({
    @required this.id,
    @required this.userName,
    @required this.photoUrl,
    @required this.email,
    @required this.displayName,
    @required this.bio,
  });
}
