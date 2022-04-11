import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salvare/database/database_paths.dart';
import 'package:salvare/model/bucket.dart';
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
      var res = await resourceRef
          .where('title', isGreaterThanOrEqualTo: title)
          .where('title', isLessThan: title + 'z')
          .get();
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

  void addBucketDB(Bucket bucket, String uid) {
    // TODO: check if total buckets is less than 10 in controller then call this func
    try {
      final bucketRef = FirebaseFirestore.instance
          .collection(uid)
          .doc(DatabasePaths.userBucketList)
          .collection(DatabasePaths.userBucketListBucket)
          .doc(bucket.id)
          .withConverter<Bucket>(
            fromFirestore: (snapshot, _) => Bucket.fromJson(snapshot.data()!),
            toFirestore: (_bucket, _) => _bucket.toJson(),
          );
      bucketRef
          .set(bucket, SetOptions(merge: true))
          .then(
              (value) => debugPrint("Added bucket! {$bucket} to user: ${uid}"))
          .catchError((err) => debugPrint("Error in User resource {$err}"));
    } catch (e) {
      debugPrint("Error in add bucket {$e}");
    }
  }

  void addUserToBucketDB(Bucket bucket, String uid) async {
    // TODO: check if total buckets is less than 10 in controller then call this func
    try {
      final bucketRef = FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .doc(DatabasePaths.userBucketList)
          .collection(DatabasePaths.userBucketListBucket)
          .withConverter<Bucket>(
            fromFirestore: (snapshot, _) => Bucket.fromJson(snapshot.data()!),
            toFirestore: (_bucket, _) => _bucket.toJson(),
          );
      // update users list in bucket
      var res = await bucketRef.where("id", isEqualTo: bucket.id).get();
      var ret = res.docs.first.data();
      if (ret.users.contains(uid) == false) {
        ret.users.add(uid);
      }
      addBucketDB(ret, FirebaseAuth.instance.currentUser!.uid);
    } catch (e) {
      debugPrint("Error in add user to bucket {$e}");
    }
  }

  Future<List<Bucket>?> fetchUserBucketList() async {
    try {
      final bucketRef = FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .doc(DatabasePaths.userBucketList)
          .collection(DatabasePaths.userBucketListBucket);
      var res = await bucketRef.get();
      var ret = res.docs.map((e) => Bucket.fromJson(e.data())).toList();
      return ret;
    } catch (e) {
      debugPrint("Error in fetch bucket {$e}");
      return null;
    }
  }

  void addResourceToBucketDB(String bucketId, Resource resource) async {
    try {
      final bucketInstanceRef = FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .doc(DatabasePaths.userBucketList)
          .collection(DatabasePaths.userBucketListBucket)
          .doc(bucketId)
          .withConverter<Bucket>(
            fromFirestore: (snapshot, _) => Bucket.fromJson(snapshot.data()!),
            toFirestore: (_bucket, _) => _bucket.toJson(),
          );
      DocumentSnapshot<Bucket> _bucketSnapshot = await bucketInstanceRef.get();
      Bucket? _bucket = _bucketSnapshot.exists ? _bucketSnapshot.data() : null;
      if (_bucket != null) {
        _bucket.users.forEach((element) {
          FirebaseFirestore.instance
              .collection(element)
              .doc(DatabasePaths.userBucketList)
              .collection(DatabasePaths.userBucketListBucket)
              .doc(bucketId)
              .collection("resources")
              .doc(resource.id)
              .withConverter<Resource>(
                fromFirestore: (snapshot, _) =>
                    Resource.fromJson(snapshot.data()!),
                toFirestore: (_resource, _) => _resource.toJson(),
              )
              .set(resource, SetOptions(merge: true))
              .then((value) => debugPrint(
                  "Resource(${resource.id}) has been added to user($element)"))
              .catchError((onError) => debugPrint(
                  "Resource(${resource.id}) CANNOT be added to user($element)"));
        });
      } else {
        debugPrint("No bucket exists with bucketID: $bucketId");
      }
    } catch (e) {
      debugPrint("Error in add resource to bucket DB {$e}");
    }
  }

  Future<List<Resource>?> fetchBucketResources(String bucketID) async {
    try {
      final resourcesRef = FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .doc(DatabasePaths.userBucketList)
          .collection(DatabasePaths.userBucketListBucket)
          .doc(bucketID)
          .collection("resources")
          .withConverter<Resource>(
            fromFirestore: (snapshot, _) => Resource.fromJson(snapshot.data()!),
            toFirestore: (_resource, _) => _resource.toJson(),
          );

      QuerySnapshot<Resource> _resources = await resourcesRef.get();
      var ret = _resources.docs.map((element) => element.data()).toList();
      return ret;
    } catch (e) {
      debugPrint("Error fetching bucket resources: $e");
    }
    return null;
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
