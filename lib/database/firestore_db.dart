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
  Future<void> addUserDB(model.User user) async {
    try {
      final userRef = FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .doc("user")
          .withConverter<model.User>(
            fromFirestore: (snapshot, _) =>
                model.User.fromJson(snapshot.data()!),
            toFirestore: (_user, _) => _user.toJson(),
          );
      final userMapRef = FirebaseFirestore.instance
          .collection("userMap")
          .doc(FirebaseAuth.instance.currentUser!.email);
      final userUIDEmailMapRef = FirebaseFirestore.instance
          .collection("userEmailMap")
          .doc(FirebaseAuth.instance.currentUser!.uid);
      model.User? _user = await fetchUserInfoDB();
      if (_user == null) {
        debugPrint("Adding new user: $user");
        try {
          await userRef.set(user);
          debugPrint("Added User! {$user}");
        } catch (err) {
          debugPrint("Error in User Addition {$err}");
        }
        if (FirebaseAuth.instance.currentUser!.email != null) {
          userMapRef
              .set({
                FirebaseAuth.instance.currentUser!.email!:
                    FirebaseAuth.instance.currentUser!.uid
              })
              .then((value) => debugPrint("Added User Map! {$user}"))
              .catchError(
                  (err) => debugPrint("Error in User Map addition {$err}"));
          userUIDEmailMapRef
              .set({
                FirebaseAuth.instance.currentUser!.uid:
                    FirebaseAuth.instance.currentUser!.email!
              })
              .then((value) => debugPrint("Added User Email UID Map! {$user}"))
              .catchError((err) =>
                  debugPrint("Error in User Email UID Map addition {$err}"));
        }
      } else {
        debugPrint("User already exists: $user");
      }
    } catch (e) {
      debugPrint("Error in addUser {$e}");
    }
  }

  Future<void> updateUserDescription(String description) async {
    try {
      final userRef = await FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .doc("user")
          .set({"description": description}, SetOptions(merge: true));
      debugPrint("Updated User description! {$description}");
      return;
    } catch (e) {
      debugPrint("Error in update user desc {$e}");
    }
  }

  Future<void> updateUserUsername(String username) async {
    try {
      final userRef = await FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .doc("user")
          .set({"userName": username}, SetOptions(merge: true));
      debugPrint("Updated User name! {$username}");
      return;
    } catch (e) {
      debugPrint("Error in update username {$e}");
    }
  }

  Future<void> updateUserDOB(DateTime dob) async {
    try {
      final userRef = await FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .doc("user")
          .set({"dob": dob}, SetOptions(merge: true));
      debugPrint("Updated User dob! {$dob}");
      return;
    } catch (e) {
      debugPrint("Error in update user dob {$e}");
    }
  }

  Future<model.User?> fetchUserInfoDB() async {
    try {
      final userRef = FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .doc("user")
          .withConverter<model.User>(
            fromFirestore: (snapshot, _) =>
                model.User.fromJson(snapshot.data()!),
            toFirestore: (_user, _) => _user.toJson(),
          );
      DocumentSnapshot<model.User> _user = await userRef.get();
      List<Bucket>? lst = await fetchUserBucketList();
      List<String>? lst2 = lst?.map((e) => e.name).toList();
      model.User? _retUser = _user.data();
      if (_retUser != null) {
        _retUser.buckets = lst2;
      }
      debugPrint("Ret User Buckets $_retUser");
      return _retUser;
    } catch (e) {
      debugPrint("Error in addUser {$e}");
    }
    return null;
  }

  Future<List<Resource>> fetchUserResourceList() async {
    try {
      final resourceRef = FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .doc(DatabasePaths.userResourceList)
          .collection(DatabasePaths.userResourceListResource)
          .withConverter<Resource>(
            fromFirestore: (snapshot, _) => Resource.fromJson(snapshot.data()!),
            toFirestore: (_resource, _) => _resource.toJson(),
          );
      var res = await resourceRef.get();
      var ret = res.docs.map((e) => e.data()).toList();
      return ret;
    } catch (e) {
      debugPrint("Error in searchResourceUsingURLDB {$e}");
    }
    return [];
  }

  void addResourceDB(Resource resource) {
    try {
      final resourceRef = FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .doc(DatabasePaths.userResourceList)
          .collection(DatabasePaths.userResourceListResource)
          .doc(resource.id)
          .withConverter<Resource>(
            fromFirestore: (snapshot, _) => Resource.fromJson(snapshot.data()!),
            toFirestore: (_resource, _) => _resource.toJson(),
          );
      resourceRef
          .set(resource, SetOptions(merge: true))
          .then((value) => debugPrint("Added resource! {$resource}"))
          .catchError((err) => debugPrint("Error in User add resource {$err}"));
    } catch (e) {
      debugPrint("Error in add resource {$e}");
    }
  }

  void editResourceDB(Resource resource) async {
    try {
      final resourceRef = FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .doc(DatabasePaths.userResourceList)
          .collection(DatabasePaths.userResourceListResource)
          .doc(resource.id)
          .withConverter<Resource>(
            fromFirestore: (snapshot, _) => Resource.fromJson(snapshot.data()!),
            toFirestore: (_resource, _) => _resource.toJson(),
          );
      resourceRef
          .set(resource, SetOptions(merge: true))
          .then((value) => debugPrint("Edited resource! {$resource}"))
          .catchError(
              (err) => debugPrint("Error in User edit resource {$err}"));
      //var res = await resourceRef.where('id', isEqualTo: resource.id);
      // debugPrint("Resource with ID: ${resource.id} has elements: ${res.docs.length}");
      // var ret = res.docs.first.data();
    } catch (e) {
      debugPrint("Error in edit resource {$e}");
    }
  }

  void addBucketDB(Bucket bucket, String uid) {
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
          .then((value) => debugPrint("Added bucket! {$bucket} to user: $uid"))
          .catchError((err) => debugPrint("Error in add bucket set {$err}"));
    } catch (e) {
      debugPrint("Error in add bucket {$e}");
    }
  }

  void deleteResourceDB(Resource resource) {
    try {
      final resourceRef = FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .doc(DatabasePaths.userResourceList)
          .collection(DatabasePaths.userResourceListResource)
          .doc(resource.id);
      resourceRef
          .delete()
          .then((value) => debugPrint("Deleted resource! ${resource.id}"))
          .catchError((err) =>
              debugPrint("Error in User delete resource ${resource.id}"));
    } catch (e) {
      debugPrint("Error in delete resource {$e}");
    }
  }

// Only deletes current users bucket
  void deleteBucketDB(Bucket bucket) async {
    try {
      var bucketRef = FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .doc(DatabasePaths.userBucketList)
          .collection(DatabasePaths.userBucketListBucket)
          .doc(bucket.id)
          .withConverter<Bucket>(
            fromFirestore: (snapshot, _) => Bucket.fromJson(snapshot.data()!),
            toFirestore: (_bucket, _) => _bucket.toJson(),
          );
      DocumentSnapshot<Bucket> _bucket = await bucketRef.get();
      if (_bucket.exists) {
        List<String> _bucketUsers = _bucket.data()!.users;
        _bucketUsers.forEach((element) async {
          // delete user from userlist of all user's buckets except current users
          if (element != FirebaseAuth.instance.currentUser!.uid) {
            debugPrint("-----------$element------------------");
            var _userBucketRef = FirebaseFirestore.instance
                .collection(element)
                .doc(DatabasePaths.userBucketList)
                .collection(DatabasePaths.userBucketListBucket)
                .doc(bucket.id)
                .withConverter<Bucket>(
                  fromFirestore: (snapshot, _) =>
                      Bucket.fromJson(snapshot.data()!),
                  toFirestore: (_bucket, _) => _bucket.toJson(),
                );
            var _userBucket = await _userBucketRef.get();
            if (_userBucket.exists) {
              debugPrint(_userBucket.data()!.id);
              var _userBucketInstance = _userBucket.data();
              _userBucketInstance!.users
                  .remove(FirebaseAuth.instance.currentUser!.uid);
              _userBucketRef.set(_userBucketInstance, SetOptions(merge: true));
            }
          }
        });
        var usersBucketRef = FirebaseFirestore.instance
            .collection(FirebaseAuth.instance.currentUser!.uid)
            .doc(DatabasePaths.userBucketList)
            .collection(DatabasePaths.userBucketListBucket)
            .doc(bucket.id);
        var usersBucketResourcesRef = FirebaseFirestore.instance
            .collection(FirebaseAuth.instance.currentUser!.uid)
            .doc(DatabasePaths.userBucketList)
            .collection(DatabasePaths.userBucketListBucket)
            .doc(bucket.id)
            .collection("resources");
        usersBucketRef.delete();
        var ret = await usersBucketResourcesRef.get();
        ret.docs.forEach((element) => element.reference.delete());
        debugPrint("Successfully deleted the bucket");
      } else {
        debugPrint(
            "Bucket with ID: ${bucket.id} doesn't exist for user(${FirebaseAuth.instance.currentUser!.uid})");
      }
    } catch (e) {
      debugPrint("Error in delete bucket {$e}");
    }
  }

  Future<String?> getUserUID(String email) async {
    try {
      final userMapRef =
          FirebaseFirestore.instance.collection("userMap").doc(email);
      var res = await userMapRef.get();
      if (res.data() != null) {
        if (res.data()!.containsKey(email)) {
          return res.data()![email];
        }
        if (res.data()!.containsKey(email) == false) {
          debugPrint("No user found with email: $email");
          return null;
        }
      }
    } catch (e) {
      debugPrint("Error in getUserUID: $e");
    }
    return null;
  }

  Future<List<String>> getUserEmails(List<String> uids) async {
    debugPrint("Pailam ---> $uids");
    List<String> emails = [];
    try {
      for (var uid in uids) {
        final userMapRef =
            FirebaseFirestore.instance.collection("userEmailMap").doc(uid);
        var res = await userMapRef.get();
        if (res.data() != null) {
          if (res.data()!.containsKey(uid)) {
            emails.add(res.data()![uid]);
          }
          if (res.data()!.containsKey(uid) == false) {
            debugPrint("No user found with uid: $uid");
            emails.add("");
          }
        }
      }
      debugPrint("Dilam ---> $emails");
      return emails;
    } catch (e) {
      debugPrint("Error in getUserEmails: $e");
    }
    return emails;
  }

  void addUserToBucketDB(String bucketID, String uid) async {
    try {
      final bucketRef = FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .doc(DatabasePaths.userBucketList)
          .collection(DatabasePaths.userBucketListBucket)
          .withConverter<Bucket>(
            fromFirestore: (snapshot, _) => Bucket.fromJson(snapshot.data()!),
            toFirestore: (_bucket, _) => _bucket.toJson(),
          );
      // update users list in buckets of all users that have this bucket
      var res = await bucketRef.where("id", isEqualTo: bucketID).get();
      if (res.docs != null) {
        var ret = res.docs.first.data();
        ret.users.forEach((element) async {
          final userBucketRef = FirebaseFirestore.instance
              .collection(element)
              .doc(DatabasePaths.userBucketList)
              .collection(DatabasePaths.userBucketListBucket)
              .withConverter<Bucket>(
                fromFirestore: (snapshot, _) =>
                    Bucket.fromJson(snapshot.data()!),
                toFirestore: (_bucket, _) => _bucket.toJson(),
              );
          var tempRes = await bucketRef.where("id", isEqualTo: bucketID).get();
          var tempRet = res.docs.first.data();
          if (tempRet.users.contains(uid) == false) {
            tempRet.users.add(uid);
          }
          addBucketDB(tempRet, element);
        });
        // adding bucket and resources to user
        var usersBucketResourcesRef = FirebaseFirestore.instance
            .collection(FirebaseAuth.instance.currentUser!.uid)
            .doc(DatabasePaths.userBucketList)
            .collection(DatabasePaths.userBucketListBucket)
            .doc(bucketID)
            .collection("resources");
        var newUsersBucketResourcesRef = FirebaseFirestore.instance
            .collection(uid)
            .doc(DatabasePaths.userBucketList)
            .collection(DatabasePaths.userBucketListBucket)
            .doc(bucketID)
            .collection("resources");
        var usersBucketResources = await usersBucketResourcesRef
            .withConverter<Resource>(
              fromFirestore: (snapshot, _) =>
                  Resource.fromJson(snapshot.data()!),
              toFirestore: (_resource, _) => _resource.toJson(),
            )
            .get();
        usersBucketResources.docs.forEach((element) {
          Resource resource = element.data();
          newUsersBucketResourcesRef
              .doc(resource.id)
              .withConverter<Resource>(
                fromFirestore: (snapshot, _) =>
                    Resource.fromJson(snapshot.data()!),
                toFirestore: (_resource, _) => _resource.toJson(),
              )
              .set(resource, SetOptions(merge: true));
        });
        if (ret.users.contains(uid) == false) {
          ret.users.add(uid);
        }
        addBucketDB(ret, uid);
      } else {
        debugPrint("No bucket found with ID: $bucketID");
      }
    } catch (e) {
      debugPrint("Error in add user to bucket {$e}");
    }
  }

  void deleteResourceFromBucket(Bucket bucket, Resource resource) async {
    try {
      final bucketRef = FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .doc(DatabasePaths.userBucketList)
          .collection(DatabasePaths.userBucketListBucket)
          .withConverter<Bucket>(
            fromFirestore: (snapshot, _) => Bucket.fromJson(snapshot.data()!),
            toFirestore: (_bucket, _) => _bucket.toJson(),
          );
      // update users list in buckets of all users that have this bucket
      var res = await bucketRef.where("id", isEqualTo: bucket.id).get();
      var ret = res.docs.first.data();

      ret.users.forEach((element) async {
        final userBucketRef = FirebaseFirestore.instance
            .collection(element)
            .doc(DatabasePaths.userBucketList)
            .collection(DatabasePaths.userBucketListBucket)
            .doc(bucket.id)
            .collection(DatabasePaths.userBucketListBucketResource)
            .doc(resource.id);
        userBucketRef.delete();
        debugPrint(
            "Deleted resource ${resource.id} from user: $element's bucket ${bucket.id}");
      });
    } catch (e) {
      debugPrint("Error in delete resource from bucket {$e}");
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

  Stream<QuerySnapshot<Bucket>> getUserBucketStream() {
    return FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc(DatabasePaths.userBucketList)
        .collection(DatabasePaths.userBucketListBucket)
        .withConverter<Bucket>(
            fromFirestore: (snapshot, _) => Bucket.fromJson(snapshot.data()!),
            toFirestore: (_bucket, _) => _bucket.toJson())
        .snapshots();
  }

  Stream<QuerySnapshot<Resource>> getBucketStream(Bucket bucket) {
    return FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc(DatabasePaths.userBucketList)
        .collection(DatabasePaths.userBucketListBucket)
        .doc(bucket.id)
        .collection(DatabasePaths.userBucketListBucketResource)
        .orderBy('dateCreated', descending: true)
        .withConverter<Resource>(
          fromFirestore: (snapshot, _) => Resource.fromJson(snapshot.data()!),
          toFirestore: (_resource, _) => _resource.toJson(),
        )
        .snapshots();
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
        for (var element in _bucket.users) {
          FirebaseFirestore.instance
              .collection(element)
              .doc(DatabasePaths.userBucketList)
              .collection(DatabasePaths.userBucketListBucket)
              .doc(bucketId)
              .collection(DatabasePaths.userBucketListBucketResource)
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
        }
      } else {
        debugPrint("No bucket exists with bucketID: $bucketId");
      }
    } catch (e) {
      debugPrint("Error in add resource to bucket DB {$e}");
    }
  }

  void editBucketResourceDB(String bucketId, Resource resource) async {
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
        for (var element in _bucket.users) {
          FirebaseFirestore.instance
              .collection(element)
              .doc(DatabasePaths.userBucketList)
              .collection(DatabasePaths.userBucketListBucket)
              .doc(bucketId)
              .collection(DatabasePaths.userBucketListBucketResource)
              .doc(resource.id)
              .withConverter<Resource>(
                fromFirestore: (snapshot, _) =>
                    Resource.fromJson(snapshot.data()!),
                toFirestore: (_resource, _) => _resource.toJson(),
              )
              .set(resource, SetOptions(merge: true))
              .then((value) => debugPrint(
                  "Resource(${resource.id}) has been edited to user($element)"))
              .catchError((onError) => debugPrint(
                  "Resource(${resource.id}) CANNOT be edited to user($element)"));
        }
      } else {
        debugPrint("No bucket exists with bucketID: $bucketId");
      }
    } catch (e) {
      debugPrint("Error in edit resource to bucket DB {$e}");
    }
  }

  void editBucketNameDB(String bucketId, String name) async {
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
        for (var element in _bucket.users) {
          FirebaseFirestore.instance
              .collection(element)
              .doc(DatabasePaths.userBucketList)
              .collection(DatabasePaths.userBucketListBucket)
              .doc(bucketId)
              .set({'name': name}, SetOptions(merge: true))
              .then((value) => debugPrint(
                  "Bucket name($name) has been edited to user($element)"))
              .catchError((onError) => debugPrint(
                  "Bucket name($name) CANNOT be edited to user($element)"));
        }
      } else {
        debugPrint("No bucket exists with bucketID: $bucketId");
      }
    } catch (e) {
      debugPrint("Error in edit bucket name to bucket DB {$e}");
    }
  }

  void editBucketDescriptionDB(String bucketId, String description) async {
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
        for (var element in _bucket.users) {
          FirebaseFirestore.instance
              .collection(element)
              .doc(DatabasePaths.userBucketList)
              .collection(DatabasePaths.userBucketListBucket)
              .doc(bucketId)
              .set({'description': description}, SetOptions(merge: true))
              .then((value) => debugPrint(
                  "Bucket description($description) has been edited to user($element)"))
              .catchError((onError) => debugPrint(
                  "Bucket description($description) CANNOT be edited to user($element)"));
        }
      } else {
        debugPrint("No bucket exists with bucketID: $bucketId");
      }
    } catch (e) {
      debugPrint("Error in edit bucket description to bucket DB {$e}");
    }
  }

  Future<List<Resource>?> fetchBucketResourcesDB(String bucketID) async {
    try {
      final resourcesRef = FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .doc(DatabasePaths.userBucketList)
          .collection(DatabasePaths.userBucketListBucket)
          .doc(bucketID)
          .collection(DatabasePaths.userBucketListBucketResource)
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

  Future<List<Resource>> searchResourceUsingCategoryDB(String category) async {
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
          .where('category', isGreaterThanOrEqualTo: category)
          .where('category', isLessThan: category + 'z')
          .get();
      //debugPrint("Search disi $category.... paisi:${lst.first}");
      return res.docs.map((e) => e.data()).toList();
    } catch (e) {
      debugPrint("Error in searchResourceUsingCategoryDB {$e}");
    }
    return [];
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

  Stream<QuerySnapshot<Resource>> getResourceStreamDB() {
    return FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc(DatabasePaths.userResourceList)
        .collection(DatabasePaths.userResourceListResource)
        .orderBy('dateCreated', descending: true)
        .withConverter<Resource>(
          fromFirestore: (snapshot, _) => Resource.fromJson(snapshot.data()!),
          toFirestore: (_resource, _) => _resource.toJson(),
        )
        .snapshots();
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

  Future<List<Resource>> searchResourceUsingTagListDB(List<Tag> _tags) async {
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
    return [];
  }
}
