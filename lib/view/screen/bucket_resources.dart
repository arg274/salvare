import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
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
  Future<List<String>> userEmails = Future.value([]);

  void _refreshEmailData() async {
    debugPrint(widget.bucket.users.toString());
    setState(() {
      userEmails = FireStoreDB().getUserEmails(widget.bucket.users);
    });
  }

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
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          Text(
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
                                                  offset:
                                                      const Offset(0.0, 0.0),
                                                  blurRadius: 10.0,
                                                  color: Colors.black
                                                      .withOpacity(0.75),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 12.0),
                                          Text(
                                            widget.bucket.description ??
                                                "No description",
                                            maxLines: 3,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4
                                                ?.apply(
                                              fontSizeFactor: .6,
                                              overflow: TextOverflow.ellipsis,
                                              color: Colors.white,
                                              shadows: <Shadow>[
                                                Shadow(
                                                  offset:
                                                      const Offset(0.0, 0.0),
                                                  blurRadius: 10.0,
                                                  color: Colors.black
                                                      .withOpacity(0.75),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
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
                                onPressed: () async {
                                  _refreshEmailData();
                                  showUserAddForm(context);
                                },
                                child: const Icon(FeatherIcons.users),
                                style: ElevatedButton.styleFrom(
                                    primary: Theme.of(context).primaryColor,
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
                                    primary: Theme.of(context).primaryColor,
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

  Future<Object?> showUserAddForm(BuildContext context) async {
    final _formkey = GlobalKey<FormState>();
    final TextEditingController _userTEC = TextEditingController();
    return await showBlurredDialog(
        context: context,
        dialogBody: AlertDialog(
          shape: dialogShape,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          actions: <Widget>[
            TextButton(
                onPressed: () async {
                  String? addedUid;
                  await bucketController.checkIfUserExists(_userTEC.text);
                  if (_formkey.currentState!.validate()) {
                    addedUid = await bucketController.addUserToBucket(
                        _userTEC.text, widget.bucket.id);
                    widget.bucket.users.add(addedUid!);
                    showToast(
                      'User added to bucket!',
                      context: context,
                      animation: StyledToastAnimation.slideFromBottom,
                      curve: Curves.decelerate,
                      duration: const Duration(seconds: 3),
                      reverseAnimation: StyledToastAnimation.fade,
                    );
                    _refreshEmailData();
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  'ADD',
                  style: Theme.of(context).textTheme.buttonText.fixFontFamily(),
                ))
          ],
          content: SingleChildScrollView(
            child: SizedBox(
              width: double.maxFinite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                    key: _formkey,
                    child: TextFormField(
                      controller: _userTEC,
                      decoration: InputDecoration(
                        labelText: 'User Email'.toUpperCase(),
                        labelStyle: Theme.of(context)
                            .textTheme
                            .formLabel
                            .fixFontFamily(),
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 5.0),
                      ),
                      onFieldSubmitted: (value) async {
                        String? addedUid;
                        await bucketController.checkIfUserExists(_userTEC.text);
                        if (_formkey.currentState!.validate()) {
                          addedUid = await bucketController.addUserToBucket(
                              _userTEC.text, widget.bucket.id);
                          widget.bucket.users.add(addedUid!);
                          showToast(
                            'User added to bucket!',
                            context: context,
                            animation: StyledToastAnimation.slideFromBottom,
                            curve: Curves.decelerate,
                            duration: const Duration(seconds: 3),
                            reverseAnimation: StyledToastAnimation.fade,
                          );
                          _refreshEmailData();
                          Navigator.pop(context);
                        }
                      },
                      validator: (email) =>
                          bucketController.validateEmail(email),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    'Users'.toUpperCase(),
                    style:
                        Theme.of(context).textTheme.formLabel.fixFontFamily(),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.4,
                      ),
                      child: FutureBuilder<List<String>>(
                          future: userEmails,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      child: ListTile(
                                        visualDensity:
                                            const VisualDensity(vertical: -4.0),
                                        onTap: () => {},
                                        leading: SizedBox(
                                          height: double.infinity,
                                          child: Icon(
                                            FeatherIcons.user,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        title: Text(
                                          snapshot.data![index]
                                              .replaceFirst('@gmail.com', ''),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        ),
                                      ),
                                    );
                                  });
                            } else if (snapshot.hasError) {
                              // TODO: Error handling
                              return Text('${snapshot.error}');
                            } else {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SpinKitCubeGrid(
                                    size: 50.0,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.color),
                              );
                            }
                          }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
