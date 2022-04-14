import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:salvare/controller/bucket_controller.dart';
import 'package:salvare/database/firestore_db.dart';
import 'package:salvare/model/bucket.dart';
import 'package:salvare/model/resource.dart';
import 'package:salvare/theme/constants.dart';
import 'package:salvare/view/component/resource_card.dart';
import 'package:salvare/view/component/resource_form.dart';

class BucketResources extends StatefulWidget {
  const BucketResources({Key? key, required this.bucket}) : super(key: key);
  final Bucket bucket;

  @override
  State<BucketResources> createState() => _BucketResourcesState();
}

class _BucketResourcesState extends State<BucketResources> {
  BucketController bucketController = BucketController();
  final bgPattern = RandomPatternGenerator();

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          statusBarColor: Colors.transparent,
        ),
        child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(290.0),
              child: Column(
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
                                    height: 250.0,
                                  ),
                                ),
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Text(
                                        widget.bucket.name,
                                        maxLines: 3,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4
                                            ?.apply(
                                          overflow: TextOverflow.ellipsis,
                                          color: Colors.white,
                                          shadows: <Shadow>[
                                            Shadow(
                                              offset: const Offset(0.0, 0.0),
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
                                child: const Icon(FeatherIcons.userPlus),
                                style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(20.0)),
                              ),
                              const SizedBox(width: 10.0),
                              ElevatedButton(
                                onPressed: () => showResourceForm(
                                  context: context,
                                  isBucketResource: true,
                                  bucket: widget.bucket,
                                ),
                                child: const Icon(FeatherIcons.plus),
                                style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(20.0)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40.0),
                  ]),
            ),
            body: StreamBuilder(
              stream: FireStoreDB().getBucketStream(widget.bucket),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  debugPrint("Error! ${snapshot.error.toString()}");
                  return const Text("Something Went Wrong");
                } else if (snapshot.hasData) {
                  try {
                    debugPrint("Firebase resource stream successfull");
                    var resources =
                        snapshot.data!.docs.map((e) => e.data()).toList();
                    return ListView.builder(
                        itemCount: resources.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: cardListEdgeInsets,
                            child: ResourceCard(
                              resource: resources[index] as Resource,
                              isBucketResource: true,
                              bucket: widget.bucket,
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
            )),
      );
}
