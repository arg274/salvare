import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salvare/database/database_paths.dart';
import 'package:salvare/model/resource.dart';
import 'package:salvare/model/user.dart' as model;

class FireStoreDB {
  void addUser(model.User user) {
    try {
      final userRef = FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .doc("user")
          .withConverter<model.User>(
            fromFirestore: (snapshot, _) =>
                model.User.fromJson(snapshot.data()!),
            toFirestore: (_user, _) => _user.toJson(),
          );
      userRef
          .set(user)
          .then((value) => debugPrint("Added User! {$user}"))
          .catchError((err) => debugPrint("Error in User Addition {$err}"));
    } catch (e) {
      debugPrint("Error in addUser {$e}");
    }
  }

  Future<dynamic>? searchResourceUsingURL(String categoryID) async {
    try {
      final resourceRef = FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .doc(DatabasePaths.userResourceList)
          .collection(DatabasePaths.userResourceListResource)
          .withConverter<Resource>(
            fromFirestore: (snapshot, _) => Resource.fromJson(snapshot.data()!),
            toFirestore: (_resource, _) => _resource.toJson(),
          );
      var res = await resourceRef
          .where(DatabasePaths.categoryID, isEqualTo: categoryID)
          .get();
      //debugPrint("Search disi $categoryID.... paisi:${lst.first}");
      return res.docs.map((e) => e.data()).toList();
    } catch (e) {
      debugPrint("Error in addUser {$e}");
    }
    return null;
  }

  void addResource(Resource resource) {
    try {
      final resourceRef = FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .doc(DatabasePaths.userResourceList)
          .collection(DatabasePaths.userResourceListResource)
          .withConverter<Resource>(
            fromFirestore: (snapshot, _) => Resource.fromJson(snapshot.data()!),
            toFirestore: (_resource, _) => _resource.toJson(),
          );
      resourceRef
          .add(resource)
          .then((value) => debugPrint("Added resource! {$resource}"))
          .catchError((err) => debugPrint("Error in User resource {$err}"));
    } catch (e) {
      debugPrint("Error in add resource {$e}");
    }
  }
}
