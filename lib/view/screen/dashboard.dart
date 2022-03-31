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
      10,
      (i) => Resource('$i', 'Resource Name $i', 'https://www.google.com',
          'Resource Description $i', DateTime.now(), DateTime.now(), null));

  _addResource(Resource resource) {
    setState(() {
      resources.add(resource);
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(
            FeatherIcons.plus,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          onPressed: () => {
            resourceController
                .addResource('https://www.prothomalo.com/')
                .then((resource) => {_addResource(resource!)})
          },
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
