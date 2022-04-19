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

  Future<void> showBucketDialogue(
      {required BuildContext context,
      bool isEdit = false,
      Bucket? bucket}) async {
    assert(!isEdit || (isEdit && bucket != null));
    final _formkey = GlobalKey<FormState>();
    final TextEditingController _bucketTEC =
        TextEditingController(text: bucket?.name);
    final TextEditingController _descTEC =
        TextEditingController(text: bucket?.description);
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: dialogShape,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            actions: <Widget>[
              TextButton(
                  onPressed: () => {
                        if (_formkey.currentState!.validate())
                          {
                            !isEdit
                                ? bucketController.addBucket(
                                    _bucketTEC.text, _descTEC.text)
                                : bucketController.editBucket(
                                    bucket!.id, _bucketTEC.text, _descTEC.text),
                            if (isEdit) Navigator.pop(context),
                            Navigator.of(context).pop()
                          }
                      },
                  child: Text(
                    isEdit ? "EDIT" : "ADD",
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
                  TextFormField(
                    controller: _bucketTEC,
                    decoration: InputDecoration(
                      labelText: 'Name'.toUpperCase(),
                      labelStyle:
                          Theme.of(context).textTheme.formLabel.fixFontFamily(),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
                    ),
                    validator: (bucketName) {
                      return bucketController.validateBucket(bucketName);
                    },
                  ),
                  const SizedBox(height: 15.0),
                  TextFormField(
                    controller: _descTEC,
                    decoration: InputDecoration(
                      labelText: 'Description'.toUpperCase(),
                      labelStyle:
                          Theme.of(context).textTheme.formLabel.fixFontFamily(),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
                    ),
                    validator: (bucketDesc) {
                      return bucketController.validateBucketDesc(bucketDesc);
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
          foregroundColor: Colors.white,
          heroTag: 'bucketBtn',
          child: const Icon(FeatherIcons.plus),
          onPressed: () => showBucketDialogue(context: context),
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
                    physics: const BouncingScrollPhysics(),
                    itemCount: buckets.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: globalEdgeInsets,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(height: 100.0),
                                Text(
                                  "Buckets",
                                  style: Theme.of(context).textTheme.headline1,
                                ),
                                const SizedBox(height: 40.0),
                              ]),
                        );
                      }
                      return InkWell(
                        child: ListTile(
                          onLongPress: () => showModalBottomSheet<void>(
                            context: context,
                            builder: (context) {
                              return Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                        onTap: () => showBucketDialogue(
                                            context: context,
                                            isEdit: true,
                                            bucket: buckets[index - 1]),
                                        leading: Icon(
                                          FeatherIcons.edit3,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              ?.color,
                                        ),
                                        title: Text(
                                          'Edit Bucket',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        )),
                                    ListTile(
                                        onTap: () async {
                                          showBucketDeleteAlert(
                                              context, buckets[index - 1]);
                                        },
                                        leading: const Icon(
                                          FeatherIcons.delete,
                                          color: Colors.red,
                                        ),
                                        title: Text(
                                          'Delete Bucket',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              ?.apply(
                                                color: Colors.red,
                                              ),
                                        )),
                                  ],
                                ),
                              );
                            },
                          ),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BucketResources(
                                      bucket: buckets[index - 1]))),
                          leading: SizedBox(
                            height: double.infinity,
                            child: Icon(
                              FeatherIcons.shoppingBag,
                              color: Theme.of(context).primaryColor,
                            ),
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

  Future<Object?> showBucketDeleteAlert(
      BuildContext context, Bucket bucket) async {
    return await showBlurredDialog(
        context: context,
        dialogBody: AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: dialogShape,
          actions: <Widget>[
            TextButton(
                onPressed: () async {
                  bucketController.deleteBucket(bucket);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Yes'.toUpperCase(),
                  style: Theme.of(context).textTheme.buttonText.fixFontFamily(),
                )),
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'No'.toUpperCase(),
                  style: Theme.of(context).textTheme.buttonText.fixFontFamily(),
                )),
          ],
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Delete'.toUpperCase(),
                style: Theme.of(context).textTheme.formLabel.fixFontFamily(),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Are you sure that you want to delete this bucket?',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        ));
  }
}
