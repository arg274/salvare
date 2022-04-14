import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salvare/theme/constants.dart';
import 'package:salvare/view/component/resource_card.dart';
import 'package:salvare/model/resource.dart';
import 'package:salvare/database/database_paths.dart';

class DashboardController {
  StreamBuilder<QuerySnapshot<Resource>> getResourceStreamBuilder() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .doc(DatabasePaths.userResourceList)
          .collection(DatabasePaths.userResourceListResource)
          .orderBy('dateCreated', descending: true)
          .withConverter<Resource>(
            fromFirestore: (snapshot, _) => Resource.fromJson(snapshot.data()!),
            toFirestore: (_resource, _) => _resource.toJson(),
          )
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          debugPrint("Error! ${snapshot.error.toString()}");
          return const Text("Something Went Wrong");
        } else if (snapshot.hasData) {
          try {
            debugPrint("Firebase resource stream successfull");
            var resources2 = snapshot.data!.docs.map((e) => e.data()).toList();
            return ListView.builder(
                itemCount: resources2.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: globalEdgeInsets,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(height: 100.0),
                            Text(
                              "Home",
                              style: Theme.of(context).textTheme.headline1,
                            ),
                            const SizedBox(height: 40.0),
                          ]),
                    );
                  }
                  return Padding(
                    padding: cardListEdgeInsets,
                    child: ResourceCard(
                        resource: resources2[index - 1] as Resource),
                  );
                });
          } catch (err) {
            return Text("Error Occured while fetching resource $err");
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
