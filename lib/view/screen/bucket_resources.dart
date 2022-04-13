import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:salvare/controller/bucket_controller.dart';
import 'package:salvare/database/firestore_db.dart';
import 'package:salvare/model/bucket.dart';
import 'package:salvare/model/resource.dart';
import 'package:salvare/theme/constants.dart';
import 'package:salvare/view/component/resource_card.dart';

class BucketResources extends StatefulWidget {
  const BucketResources({Key? key, required this.bucket}) : super(key: key);
  final Bucket bucket;

  @override
  State<BucketResources> createState() => _BucketResourcesState();
}

class _BucketResourcesState extends State<BucketResources> {
  BucketController bucketController = BucketController();
  final bgPattern = RandomPatternGenerator();

  Future<void> showAddLinkDialogue(BuildContext context) async {
    final _formkey = GlobalKey<FormState>();
    Resource? _resource;
    return await showDialog(
        context: context,
        builder: (context) {
          final TextEditingController _urlTEC = TextEditingController();
          final TextEditingController _titleTEC = TextEditingController();
          final TextEditingController _descTEC = TextEditingController();
          return AlertDialog(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              actions: <Widget>[
                TextButton(
                    onPressed: () => {
                          if (_formkey.currentState!.validate())
                            {
                              if (_resource != null)
                                {
                                  _resource!.title = _titleTEC.text,
                                  _resource!.description = _descTEC.text,
                                  bucketController.addResourceToBucket(
                                      widget.bucket, _resource!),
                                  resourceController.addResource(_resource!),
                                },
                              Navigator.of(context).pop()
                            }
                        },
                    child: Text(
                      'ADD',
                      style: Theme.of(context)
                          .textTheme
                          .buttonText
                          .fixFontFamily(),
                    ))
              ],
              content: SingleChildScrollView(
                child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'URL',
                          style: Theme.of(context)
                              .textTheme
                              .formLabel
                              .fixFontFamily(),
                        ),
                        TextFormField(
                          controller: _urlTEC,
                          onChanged: (url) => {
                            if (_formkey.currentState!.validate())
                              {
                                // TODO: Fix race condition
                                resourceController
                                    .refreshResource(
                                        _urlTEC.text, 'Default', null)
                                    .then((resource) => {
                                          _resource = resource,
                                          _titleTEC.text = resource!.title,
                                          _descTEC.text = resource.description,
                                        }),
                              }
                          },
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                          ),
                          validator: (url) {
                            return resourceController.validateURL(url);
                          },
                        ),
                        const SizedBox(height: 15.0),
                        Text(
                          'Title',
                          style: Theme.of(context)
                              .textTheme
                              .formLabel
                              .fixFontFamily(),
                        ),
                        TextFormField(
                          controller: _titleTEC,
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        Text(
                          'Description',
                          style: Theme.of(context)
                              .textTheme
                              .formLabel
                              .fixFontFamily(),
                        ),
                        TextFormField(
                          controller: _descTEC,
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                          ),
                        ),
                      ],
                    )),
              ));
        });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
          body: SafeArea(
        child: StreamBuilder(
          stream: FireStoreDB().getBucketStream(widget.bucket),
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
                            children: [
                              Stack(
                                children: [
                                  Column(
                                    children: [
                                      Stack(
                                        children: <Widget>[
                                          CustomPaint(
                                            painter: bgPattern,
                                            child: Container(
                                              height: 200.0,
                                            ),
                                          ),
                                          Positioned.fill(
                                            child: Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: Text(
                                                  widget.bucket.name,
                                                  maxLines: 3,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline4
                                                      ?.apply(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    color: Colors.white,
                                                    shadows: <Shadow>[
                                                      Shadow(
                                                        offset: const Offset(
                                                            0.0, 0.0),
                                                        blurRadius: 10.0,
                                                        color: Colors.black
                                                            .withOpacity(0.75),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 30.0),
                                    ],
                                  ),
                                  Positioned(
                                    right: 20.0,
                                    bottom: 0.0,
                                    child: Row(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () => {},
                                          child:
                                              const Icon(FeatherIcons.userPlus),
                                          style: ElevatedButton.styleFrom(
                                              shape: const CircleBorder(),
                                              padding:
                                                  const EdgeInsets.all(20.0)),
                                        ),
                                        const SizedBox(width: 10.0),
                                        ElevatedButton(
                                          onPressed: () =>
                                              showAddLinkDialogue(context),
                                          child: const Icon(FeatherIcons.plus),
                                          style: ElevatedButton.styleFrom(
                                              shape: const CircleBorder(),
                                              padding:
                                                  const EdgeInsets.all(20.0)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 40.0),
                            ]);
                      }
                      return Padding(
                        padding: globalEdgeInsets,
                        child: ResourceCard(
                            resource: resources[index - 1] as Resource),
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
      ));
}
