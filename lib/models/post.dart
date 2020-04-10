import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Post {
  final String id;
  final String ownerId;
  final String mediaUrl;
  final String description;
  final String location;
  final Timestamp timeStamp;
  Map likes;

  Post({
    @required this.id,
    @required this.ownerId,
    @required this.mediaUrl,
    @required this.description,
    @required this.location,
    @required this.timeStamp,
    this.likes = const {},
  });
}
