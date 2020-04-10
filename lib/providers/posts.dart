import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/post.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class Posts with ChangeNotifier {
  final String _userId;
  final _postsRef = Firestore.instance.collection('posts');
  StorageReference _storageRef = FirebaseStorage.instance.ref();

  Posts(this._userId, this._posts);

  List<Post> _posts = [];

  List<Post> get posts {
    return _posts;
  }

  Future<void> addPost(File image, String description, String location) async {
    String postId = Uuid().v4();

    String imagUrl = await uploadImageToStorage(image, postId);

    if (imagUrl != null) {
      Post newPost = Post(
          id: postId,
          description: description,
          location: location,
          mediaUrl: imagUrl,
          ownerId: _userId,
          timeStamp: Timestamp.now());

      await _postsRef
          .document(_userId)
          .collection('userPosts')
          .document(postId)
          .setData({
        'id': newPost.id,
        'ownerId': newPost.ownerId,
        'description': newPost.description,
        'location': newPost.location,
        'mediaUrl': newPost.mediaUrl,
        'timeStamp': newPost.timeStamp,
        'likes': {}
      }).catchError((error) {
        throw Exception('upload Post error');
      });
    } else {
      throw Exception('image error');
    }
  }

  Future<String> uploadImageToStorage(File image, String postId) async {
    StorageUploadTask uploadTask =
        _storageRef.child("post_$postId.jpg").putFile(image);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
    /*} catch (error) {
      return null;
    }*/
  }

  Future<void> fetchAndSetPosts() async {
    try {
      final QuerySnapshot extractedPosts = await _postsRef
          .document(_userId)
          .collection('userPosts')
          .orderBy('timeStamp')
          .getDocuments();
      List<Post> postslist = extractedPosts.documents
          .map((document) => Post(
              id: document.data['id'],
              ownerId: document.data['ownerId'],
              mediaUrl: document.data['mediaUrl'],
              description: document.data['description'],
              location: document.data['location'],
              timeStamp: document.data['timeStamp']))
          .toList();
      _posts = postslist;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
