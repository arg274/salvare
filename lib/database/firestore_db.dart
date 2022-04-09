import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salvare/database/database_paths.dart';
import 'package:salvare/model/resource.dart';
import 'package:salvare/model/tag.dart';
import 'package:salvare/model/user.dart' as model;

class FireStoreDB {
  // TODO: Find place to call addUser from
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

  Future<List<Resource>?>? searchResourceUsingTitleDB(String title) async {
    try {
      final resourceRef = FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .doc(DatabasePaths.userResourceList)
          .collection(DatabasePaths.userResourceListResource)
          .withConverter<Resource>(
            fromFirestore: (snapshot, _) => Resource.fromJson(snapshot.data()!),
            toFirestore: (_resource, _) => _resource.toJson(),
          );
      var res = await resourceRef.where("title", isEqualTo: title).get();
      //debugPrint("Search disi $category.... paisi:${lst.first}");
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

  void addCategoryDB(String category) {
    try {
      final categoryRef = FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .doc(DatabasePaths.userCategoryList);
      categoryRef
          .set({
            DatabasePaths.userCategoryListCategory:
                FieldValue.arrayUnion([category])
          }, SetOptions(merge: true))
          .then((value) => debugPrint("Updated category! {$category}"))
          .catchError((err) => debugPrint("Error in add category {$err}"));
    } catch (e) {
      debugPrint("Error in add category {$e}");
    }
  }

  Future<List<String>?> fetchCategoriesDB() async {
    try {
      final categoryRef = FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .doc(DatabasePaths.userCategoryList);

      var res = await categoryRef.get();
      if (res.exists) {
        var ret = res.data()![DatabasePaths.userCategoryListCategory] as List;
        debugPrint("Category list size: ${ret.length}");
        ret = ret.map((e) => e.toString()).toList();
        return ret as List<String>;
      }
    } catch (e) {
      debugPrint("Error in fetch category db {$e}");
    }
    return null;
  }

  void addTagDB(Tag tag) async {
    try {
      final tagRef = FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .doc("tagArray");
      tagRef
          .set({
            "tags": FieldValue.arrayUnion([tag.toJson()])
          }, SetOptions(merge: true))
          .then((value) => debugPrint("Updated tag! {$tag}"))
          .catchError((err) => debugPrint("Error in add tag {$err}"));
    } catch (e) {
      debugPrint("Error in add tag {$e}");
    }
  }

  Future<List<Tag>?> fetchTagsDB() async {
    try {
      final tagRef = FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .doc(DatabasePaths.userTagList);

      var res = await tagRef.get();
      if (res.exists) {
        var ret = res.data()![DatabasePaths.userTagListTag] as List;
        debugPrint("Tag list size: ${ret.length}");
        ret = ret.map((e) => Tag.fromJson(e)).toList();
        return ret as List<Tag>;
      }
    } catch (e) {
      debugPrint("Error in add tag db {$e}");
    }
    return null;
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
      // ignore: prefer_typing_uninitialized_variables
      var res;
      List<Resource> ret = [];
      try {
        res = await resourceRef.where('tags', isNull: false).get();
        res = res.docs.map((e) => e.data()).toList();
        for (var element in (res as List)) {
          List<Tag>? taglist = (element as Resource).tags;
          taglist?.forEach((tagElem) {
            if (tagElem.name == _tag.name) {
              ret.add(element);
            }
          });
        }
      } catch (err) {
        debugPrint("searchResourceUsingTagDB Bhitrer error. $err");
      }
      //debugPrint("Search disi $category.... paisi:${lst.first}");
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
        for (var element in (res as List)) {
          List<Tag>? taglist = (element as Resource).tags;
          bool _match = true;
          for (var _tagElement in _tags) {
            _match &= (taglist == null)
                ? false
                : taglist.any((tagElem) => _tagElement.name == tagElem.name);
          }
          if (_match == true) {
            ret.add(element);
          }
        }
      } catch (err) {
        debugPrint("searchResourceUsingTagDB Bhitrer error. $err");
      }
      //debugPrint("Search disi $category.... paisi:${lst.first}");
      return ret;
    } catch (e) {
      debugPrint("Error in searchResourceUsingTagsDB {$e}");
    }
    return null;
  }
}
