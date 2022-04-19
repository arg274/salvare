import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:salvare/database/database_paths.dart';
import 'package:salvare/database/firestore_db.dart';
import 'package:salvare/model/bucket.dart';
import 'package:salvare/model/resource.dart';
import 'package:flutter/foundation.dart';
import 'package:validators/validators.dart';

class BucketController {
  int totalBuckets = 0;
  bool userExists = false;

  void addBucket(String bucketName, String bucketDesc) async {
    try {
      // fetch total number of buckets and update totalBuckets
      List<Bucket>? userBucketList = await FireStoreDB().fetchUserBucketList();
      totalBuckets = userBucketList == null ? 0 : userBucketList.length;
      debugPrint(
          "${FirebaseAuth.instance.currentUser!.email} has total $totalBuckets buckets");
      if (totalBuckets < DatabasePaths.userMaxBucket) {
        FireStoreDB().addBucketDB(
            Bucket.unlaunched(
                bucketName, bucketDesc, FirebaseAuth.instance.currentUser!.uid),
            FirebaseAuth.instance.currentUser!.uid.toString());
        totalBuckets++;
      } else {
        debugPrint("Max number of buckets exceeded");
        // TODO show toast
      }
    } catch (err) {
      debugPrint("error in add bucket dummy {$err}");
    }
  }

  void editBucket(String bucketID, String bucketName, String bucketDesc) async {
    FireStoreDB().editBucketNameDB(bucketID, bucketName);
    FireStoreDB().editBucketDescriptionDB(bucketID, bucketDesc);
  }

  void deleteBucket(Bucket bucket) async {
    try {
      // fetch total number of buckets and update totalBuckets
      List<Bucket>? userBucketList = await FireStoreDB().fetchUserBucketList();
      totalBuckets = userBucketList == null ? 0 : userBucketList.length;
      debugPrint(
          "${FirebaseAuth.instance.currentUser!.email} has total $totalBuckets buckets");
      if (totalBuckets < DatabasePaths.userMaxBucket) {
        FireStoreDB().deleteBucketDB(bucket);
        totalBuckets--;
      } else {
        debugPrint("Max number of buckets exceeded");
        // TODO show toast
      }
    } catch (err) {
      debugPrint("error in add bucket dummy {$err}");
    }
  }

  void addBucketDummy() async {
    try {
      // fetch total number of buckets and update totalBuckets
      List<Bucket>? userBucketList = await FireStoreDB().fetchUserBucketList();
      totalBuckets = userBucketList == null ? 0 : userBucketList.length;
      debugPrint(
          "${FirebaseAuth.instance.currentUser!.email} has total $totalBuckets buckets");
      if (totalBuckets < DatabasePaths.userMaxBucket) {
        Bucket _bucket = Bucket.unlaunched(
            'bucket1', 'bucketdesc1', FirebaseAuth.instance.currentUser!.uid);
        FireStoreDB().addBucketDB(
            _bucket, FirebaseAuth.instance.currentUser!.uid.toString());
        totalBuckets++;
      } else {
        debugPrint("Max number of buckets exceeded");
      }
    } catch (err) {
      debugPrint("error in add bucket dummy {$err}");
    }
  }

  void addBucketResource(Bucket bucket, Resource resource) {
    try {
      FireStoreDB().addResourceToBucketDB(bucket.id, resource);
    } catch (err) {
      debugPrint("error in add resource to bucket dummy {$err}");
    }
  }

  void editBucketResource(Bucket bucket, Resource resource) =>
      FireStoreDB().editBucketResourceDB(bucket.id, resource);

  void deleteBucketResource(Bucket bucket, Resource resource) {
    try {
      FireStoreDB().deleteResourceFromBucket(bucket, resource);
    } catch (err) {
      debugPrint("error in add resource to bucket dummy {$err}");
    }
  }

  void addResourceToBucketDummy() {
    try {
      Resource resource = Resource.unlaunched('dummyResourceID2',
          'dummyResourceName2', 'www.goal.com', 'dummyResourceCategory2');
      String bucketId = "1dc29fd7e97e4e8cdd1117f7b8e28f22";
      FireStoreDB().addResourceToBucketDB(bucketId, resource);
    } catch (err) {
      debugPrint("error in add resource to bucket dummy {$err}");
    }
  }

  void addUserToBucketDummy() async {
    try {
      Timer(const Duration(seconds: 5), () async {
        debugPrint("Yeah, this line is printed after 3 seconds");
        List<Bucket>? userBucketList =
            await FireStoreDB().fetchUserBucketList();
        totalBuckets = userBucketList == null ? 0 : userBucketList.length;

        debugPrint(
            "${FirebaseAuth.instance.currentUser!.email} has total $totalBuckets buckets");
        if (totalBuckets == 0) {
          debugPrint("can't add bucket as no bucket exists");
        } else {
          FireStoreDB().addUserToBucketDB(
              userBucketList!.first.id, "68oiCcs9aDQOaZvd6mtHResXBfj2");
          Timer(const Duration(seconds: 5), () async {
            // also add bucket for added user
            debugPrint(
                "Adding uid: 68oiCcs9aDQOaZvd6mtHResXBfj2 to bucket with id: ${userBucketList.first.id}");
            List<Bucket>? ust = await FireStoreDB().fetchUserBucketList();
            FireStoreDB()
                .addBucketDB(ust!.first, "68oiCcs9aDQOaZvd6mtHResXBfj2");
          });
        }
      });
    } catch (err) {
      debugPrint("error in add user to bucket dummy {$err}");
    }
  }

  Future<String?> addUserToBucket(String email, String bucketID) async {
    try {
      String? _uid = await FireStoreDB().getUserUID(email);
      if (_uid == null) {
        debugPrint("User doesn't have an account in salvare!");
      } else {
        debugPrint("User does have an account in salvare! $_uid");
        FireStoreDB().addUserToBucketDB(bucketID, _uid);
        return _uid;
      }
    } catch (err) {
      debugPrint("error in add user to bucket dummy {$err}");
    }
  }

  Future<void> checkIfUserExists(String email) async {
    try {
      userExists =
          (await FireStoreDB().getUserUID(email)) == null ? false : true;
    } catch (err) {
      debugPrint("error in add user to bucket dummy {$err}");
      userExists = false;
    }
  }

  Future<List<Resource>?> fetchBucketResources(Bucket bucket) async {
    try {
      List<Resource>? lst =
          await FireStoreDB().fetchBucketResourcesDB(bucket.id);
      debugPrint("Bucket(${bucket.id}) has no of resources =  ${lst?.length}");
      return lst;
    } catch (e) {
      debugPrint("Error in fetchBucketResourcesDummy: $e");
    }
    return null;
  }

  void fetchBucketResourcesDummy() async {
    String dummyBucketID = "1dc29fd7e97e4e8cdd1117f7b8e28f22";
    try {
      List<Resource>? lst =
          await FireStoreDB().fetchBucketResourcesDB(dummyBucketID);
      debugPrint("Bucket($dummyBucketID) has resources: ${lst?.length}");
    } catch (e) {
      debugPrint("Error in fetchBucketResourcesDummy: $e");
    }
  }

  String? validateBucket(String? bucketName) {
    if (bucketName == null || bucketName.isEmpty) {
      return 'Please enter a name';
    } else {
      return null;
    }
  }

  String? validateBucketDesc(String? bucketDesc) {
    if (bucketDesc == null || bucketDesc.isEmpty) {
      return 'Please enter a description';
    } else {
      return null;
    }
  }

  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Please enter an email';
    } else if (!isEmail(email)) {
      return 'Please enter a valid email';
    } else {
      return userExists ? null : 'User does not exist';
    }
  }
}
