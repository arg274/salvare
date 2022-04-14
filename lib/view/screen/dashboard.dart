import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:salvare/controller/dashboard_controller.dart';
import 'package:salvare/controller/resource_controller.dart';
import 'package:salvare/controller/tag_category_controller.dart';
import 'package:salvare/main.dart';
import 'package:salvare/model/resource.dart';
import 'package:salvare/model/tag.dart';
import 'package:salvare/theme/constants.dart';
import 'package:salvare/view/component/resource_card.dart';
import 'package:salvare/view/component/resource_form.dart';
import 'package:salvare/view/screen/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final ResourceController resourceController = ResourceController();
  final TagCategoryController tagCategoryController = TagCategoryController();

  Future<Object?> showAddCategoryDialogue(BuildContext context) async {
    final _formkey = GlobalKey<FormState>();
    final TextEditingController _catTEC = TextEditingController();
    return await showBlurredDialog(
        context: context,
        dialogBody: AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          actions: <Widget>[
            TextButton(
                onPressed: () => {
                      if (_formkey.currentState!.validate())
                        {
                          tagCategoryController.addCategory(_catTEC.text),
                          Navigator.of(context).pop()
                        }
                    },
                child: Text(
                  'ADD',
                  style: Theme.of(context).textTheme.buttonText.fixFontFamily(),
                ))
          ],
          content: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Category'.toUpperCase(),
                  style: Theme.of(context).textTheme.formLabel.fixFontFamily(),
                ),
                TextFormField(
                  controller: _catTEC,
                  onChanged: (category) => {},
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                  ),
                  validator: (category) {
                    return resourceController.validateCategory(category);
                  },
                ),
              ],
            ),
          ),
        ));
  }

  Future<Object?> showAddTagDialogue(BuildContext context) async {
    final _formkey = GlobalKey<FormState>();
    final TextEditingController _tagTEC = TextEditingController();
    return await showBlurredDialog(
        context: context,
        dialogBody: AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          actions: <Widget>[
            TextButton(
                onPressed: () => {
                      if (_formkey.currentState!.validate())
                        {
                          tagCategoryController
                              .addTag(Tag.unlaunched(_tagTEC.text, 0xFFFFC107)),
                          Navigator.of(context).pop()
                        }
                    },
                child: Text(
                  'ADD',
                  style: Theme.of(context).textTheme.buttonText.fixFontFamily(),
                ))
          ],
          content: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Tag'.toUpperCase(),
                  style: Theme.of(context).textTheme.formLabel.fixFontFamily(),
                ),
                TextFormField(
                  controller: _tagTEC,
                  onChanged: (tag) => {},
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                  ),
                  validator: (tag) {
                    return resourceController.validateTag(tag);
                  },
                ),
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: SpeedDial(
          icon: FeatherIcons.plus,
          activeIcon: FeatherIcons.x,
          children: [
            SpeedDialChild(
              child: const Icon(FeatherIcons.link),
              backgroundColor:
                  DynamicColorTheme.getInstance().primarySwatch[600],
              foregroundColor: Colors.white,
              label: 'Resource',
              onTap: () => showResourceForm(context: context),
            ),
            SpeedDialChild(
              child: const Icon(FeatherIcons.folder),
              backgroundColor:
                  DynamicColorTheme.getInstance().primarySwatch[700],
              foregroundColor: Colors.white,
              label: 'Category',
              onTap: () => showAddCategoryDialogue(context),
            ),
            SpeedDialChild(
              child: const Icon(FeatherIcons.tag),
              backgroundColor:
                  DynamicColorTheme.getInstance().primarySwatch[800],
              foregroundColor: Colors.white,
              label: 'Tag',
              onTap: () => showAddTagDialogue(context),
            ),
          ],
        ),
        body: StreamBuilder(
          stream: DashboardController().getResourceStream(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              debugPrint("Error! ${snapshot.error.toString()}");
              return const Text("Something Went Wrong");
            } else if (snapshot.hasData) {
              try {
                debugPrint("Firebase resource stream successfull");
                var resources2 =
                    snapshot.data!.docs.map((e) => e.data()).toList();
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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Home",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1,
                                      ),
                                      FloatingActionButton(
                                        heroTag: "profileBtn",
                                        child: const Icon(FeatherIcons.user),
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        // onPressed: () {
                                        //   Salvare.notifier.value =
                                        //       Salvare.notifier.value ==
                                        //               lightTheme
                                        //           ? darkTheme
                                        //           : lightTheme;
                                        // },
                                        onPressed: () async {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const ProfilePage()),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 40.0),
                                ]));
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
        ),
      );
}
