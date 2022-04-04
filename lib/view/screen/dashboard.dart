import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:salvare/controller/resource_controller.dart';
import 'package:salvare/view/component/resource_card.dart';
import 'package:salvare/model/resource.dart';
import 'package:salvare/theme/constants.dart';
import 'package:salvare/utils.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final ResourceController resourceController = ResourceController();
  List<Resource> resources = List<Resource>.generate(
      0,
      (i) => Resource(
          '$i',
          'Resource Name $i',
          'https://www.google.com',
          'default',
          null,
          'Resource Description $i',
          DateTime.now(),
          DateTime.now(),
          null));

  _addResource(Resource resource) {
    setState(() {
      resources.add(resource);
    });
  }

  Future<void> showAddLinkDialogue(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          final TextEditingController _teController = TextEditingController();
          return AlertDialog(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              actions: <Widget>[
                TextButton(
                    onPressed: () => {
                          resourceController
                              .addResource(_teController.text)
                              .then((resource) => {_addResource(resource!)}),
                          Navigator.of(context).pop()
                        },
                    child: Text(
                      'ADD',
                      style: Theme.of(context).textTheme.bodyText1,
                    ))
              ],
              content: Form(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'URL',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  TextFormField(
                    controller: _teController,
                    validator: (url) {
                      return resourceController.validateURL(url);
                    },
                  )
                ],
              )));
        });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: FloatingActionButton(
          heroTag: "btn2",
          child: Icon(
            FeatherIcons.plus,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          onPressed: () => {showAddLinkDialogue(context)},
        ),
        body: SafeArea(
          child: Padding(
            padding: globalEdgeInsets,
            child: ListView.builder(
                itemCount: resources.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: 100.0),
                          Text(
                            "Home",
                            style: Theme.of(context).textTheme.headline1,
                          ),
                          const SizedBox(height: 40.0),
                        ]);
                  }

                  return ResourceCard(resource: resources[index - 1]);
                }),
          ),
        ),
      );
}
