import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:salvare/controller/bucket_controller.dart';
import 'package:salvare/database/firestore_db.dart';
import 'package:salvare/model/bucket.dart';
import 'package:salvare/theme/constants.dart';

import 'bucket_resources.dart';

class Buckets extends StatefulWidget {
  const Buckets({Key? key}) : super(key: key);

  @override
  State<Buckets> createState() => _BucketsState();
}

class _BucketsState extends State<Buckets> {
  BucketController bucketController = BucketController();

  Future<void> showAddBucketDialogue(BuildContext context) async {
    final _formkey = GlobalKey<FormState>();
    final TextEditingController _bucketTEC = TextEditingController();
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            actions: <Widget>[
              TextButton(
                  onPressed: () => {
                        if (_formkey.currentState!.validate())
                          {
                            bucketController.addBucket(_bucketTEC.text),
                            Navigator.of(context).pop()
                          }
                      },
                  child: Text(
                    'ADD',
                    style:
                        Theme.of(context).textTheme.buttonText.fixFontFamily(),
                  ))
            ],
            content: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Name',
                    style:
                        Theme.of(context).textTheme.formLabel.fixFontFamily(),
                  ),
                  TextFormField(
                    controller: _bucketTEC,
                    onChanged: (category) => {},
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                    ),
                    validator: (bucketName) {
                      return bucketController.validateBucket(bucketName);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: FloatingActionButton(
          heroTag: 'bucketBtn',
          child: const Icon(FeatherIcons.plus),
          onPressed: () => showAddBucketDialogue(context),
        ),
        body: StreamBuilder<QuerySnapshot<Bucket>>(
          stream: FireStoreDB().getUserBucketStream(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              debugPrint("Error! ${snapshot.error.toString()}");
              return const Text("Something Went Wrong");
            } else if (snapshot.hasData) {
              try {
                debugPrint("Firebase resource stream successfull");
                var buckets = snapshot.data!.docs.map((e) => e.data()).toList();
                return ListView.builder(
                    itemCount: buckets.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(height: 100.0),
                              Text(
                                "Buckets",
                                style: Theme.of(context).textTheme.headline1,
                              ),
                              const SizedBox(height: 40.0),
                            ]);
                      }
                      return InkWell(
                        child: ListTile(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BucketResources(
                                      bucket: buckets[index - 1]))),
                          leading: const SizedBox(
                            height: double.infinity,
                            child: Icon(FeatherIcons.shoppingBag),
                          ),
                          title: Text(
                            buckets[index - 1].name,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          subtitle: Text(
                            '${buckets[index - 1].users.length} user(s)',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                      );
                    });
              } catch (err) {
                return Text("Error Occured while fetching resource $err");
              }
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      );
}
