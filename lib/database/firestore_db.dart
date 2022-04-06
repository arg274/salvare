import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salvare/database/database_paths.dart';
import 'package:salvare/model/resource.dart';
import 'package:salvare/model/tag.dart';
import 'package:salvare/model/user.dart' as model;

class FireStoreDB {
  void addUserDB(model.User user) {
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

  Future<List<Resource>?>? searchResourceUsingURLDB(String categoryID) async {
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
      debugPrint("Error in searchResourceUsingURLDB {$e}");
    }
    return null;
  }

  void addResourceDB(Resource resource) {
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

  Future<List<Resource>?> searchResourceUsingTagDB(Tag _tag) async {
    try {
      final resourceRef = FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .doc(DatabasePaths.userResourceList)
          .collection(DatabasePaths.userResourceListResource)
          .withConverter<Resource>(
            fromFirestore: (snapshot, _) => Resource.fromJson(snapshot.data()!),
            toFirestore: (_resource, _) => _resource.toJson(),
          );
      var res;
      List<Resource> ret = [];
      try {
        res = await resourceRef.where('tags', isNull: false).get();
        res = res.docs.map((e) => e.data()).toList();
        (res as List).forEach((element) {
          List<Tag>? taglist = (element as Resource).tags;
          taglist?.forEach((tagElem) {
            if (tagElem.name == _tag.name) {
              ret.add(element);
            }
          });
        });
      } catch (err) {
        print("searchResourceUsingTagDB Bhitrer error. $err");
      }
      //debugPrint("Search disi $categoryID.... paisi:${lst.first}");
      return ret;
    } catch (e) {
      debugPrint("Error in searchResourceUsingTagsDB {$e}");
    }
    return null;
  }

  Future<List<Resource>?> searchResourceUsingTagListDB(List<Tag> _tags) async {
    try {
      final resourceRef = FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .doc(DatabasePaths.userResourceList)
          .collection(DatabasePaths.userResourceListResource)
          .withConverter<Resource>(
            fromFirestore: (snapshot, _) => Resource.fromJson(snapshot.data()!),
            toFirestore: (_resource, _) => _resource.toJson(),
          );
      var res;
      List<Resource> ret = [];
      try {
        res = await resourceRef.where('tags', isNull: false).get();
        res = res.docs.map((e) => e.data()).toList();
        (res as List).forEach((element) {
          List<Tag>? taglist = (element as Resource).tags;
          // taglist?.forEach((tagElem) {
          //   _tags.forEach((_tag) {
          //     if (tagElem.name == _tag.name) {
          //       _tags.remove(_tag);
          //     }
          //   });
          // });
          // if (_tags.isEmpty) {
          //   ret.add(element);
          // }
          bool _match = true;
          _tags.forEach((_tagElement) {
            _match &= (taglist == null)
                ? false
                : taglist.any((tagElem) => _tagElement.name == tagElem.name);
          });
          if (_match == true) {
            ret.add(element);
          }
        });
      } catch (err) {
        print("searchResourceUsingTagDB Bhitrer error. $err");
      }
      //debugPrint("Search disi $categoryID.... paisi:${lst.first}");
      return ret;
    } catch (e) {
      debugPrint("Error in searchResourceUsingTagsDB {$e}");
    }
    return null;
  }
}
