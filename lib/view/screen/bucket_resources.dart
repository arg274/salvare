import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:salvare/database/firestore_db.dart';
import 'package:salvare/model/bucket.dart';
import 'package:salvare/model/resource.dart';
import 'package:salvare/theme/constants.dart';
import 'package:salvare/view/component/resource_card.dart';

class BucketResources extends StatelessWidget {
  const BucketResources({Key? key, required this.bucket}) : super(key: key);
  final Bucket bucket;

  @override
  Widget build(BuildContext context) => Scaffold(
          body: SafeArea(
        child: Padding(
          padding: globalEdgeInsets,
          child: StreamBuilder(
            stream: FireStoreDB().getBucketStream(bucket),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                debugPrint("Error! ${snapshot.error.toString()}");
                return const Text("Something Went Wrong");
              } else if (snapshot.hasData) {
                try {
                  debugPrint("Firebase resource stream successfull");
                  var resources =
                      snapshot.data!.docs.map((e) => e.data()).toList();
                  return ListView.builder(
                      itemCount: resources.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(height: 100.0),
                                Text(
                                  bucket.name,
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                                const SizedBox(height: 40.0),
                              ]);
                        }
                        return ResourceCard(
                            resource: resources[index - 1] as Resource);
                      });
                } catch (err) {
                  return Text("Error Occured while fetching resource $err");
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ));
}
