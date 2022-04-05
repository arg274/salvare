import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:salvare/model/resource.dart';
import 'package:salvare/model/user.dart' as model_user;

import '../model/tag.dart';

class FirebaseUtility {
  final User user;
  FirebaseUtility({required this.user});

  final _database = FirebaseDatabase.instance.ref();
  void addDummyData(String value, String path) {
    _database
        .child("${user.uid}/$path")
        .set(value)
        .then((_) => debugPrint("Dummy Data added to firebase!"))
        .catchError((err) => debugPrint("Dummy Data adding error: $err!"));
  }

  void addResourceDB(Resource resource) {
    // Add resource to user's list of resources
    // Add resource to tag's list of resources
    // Add resource to category's list of resources
  }
  void addUserDB(model_user.User user) {}
  void addCategoryDB(Category category) {}
  void addTagDB(Tag tag) {}
}
