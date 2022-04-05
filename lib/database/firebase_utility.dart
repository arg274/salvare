import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:salvare/model/resource.dart';
import 'package:salvare/model/user.dart' as model_user;

import '../model/tag.dart';
import 'database_paths.dart';

class FirebaseUtility {
  final User user;
  late final DatabaseReference _databaseRef;
  late final DatabaseReference _databaseUserRef;

  FirebaseUtility({required this.user}) {
    try {
      _databaseRef = FirebaseDatabase.instance.ref();
      _databaseUserRef =
          _databaseRef.child("${DatabasePaths.userList}/${user.uid}/");
    } catch (err) {
      debugPrint("Couldn't get _database reference! Error: $err");
    }
  }

  Future<Resource?>? searchResourceDB(String resourceID) {
    _databaseUserRef
        .child('${DatabasePaths.resourceList}/')
        .orderByKey()
        .get()
        .then((value) {
      debugPrint("Search value result: ${value.value}");
      var listofResources = (value.value) as Map;
      Resource? val;
      listofResources.forEach((key, _val) {
        var resource = _val as Map;
        debugPrint("Resource Considering: ${resource['id']}");
        if (resource['id'] == resourceID) {
          debugPrint("Paisi value: $resource");
          val = Resource.fromJson(jsonDecode(resource.toString()));
        }
      });
      return val;
    }).catchError((err) {
      debugPrint("Error in Search: $err");
    });
  }

  void addDummyData(String value, String path) {
    _databaseRef
        .child("${user.uid}/$path")
        .set(value)
        .then((_) => debugPrint("Dummy Data added to firebase!"))
        .catchError((err) => debugPrint("Dummy Data adding error: $err!"));
  }

  void addResourceDB(Resource resource) {
    // Add resource to user's list of resources
    String categoryID = resource.categoryID;
    _databaseUserRef
        .child('${DatabasePaths.resourceList}/')
        .push()
        .set(resource.toJson())
        .then((_) => debugPrint("Successfully added resource to DB"))
        .catchError((err) => debugPrint("Add Resource DB error: $err"));
    // Add resource to tag's list of resources
    // Add resource to category's list of resources
  }

  void addUserDB(model_user.User user) {}
  void addCategoryDB(Category category) {}
  void addTagDB(Tag tag) {}
}
