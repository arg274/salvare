import 'package:flutter/material.dart';
import 'package:salvare/theme/constants.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: globalEdgeInsets,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 100.0),
                  Text(
                    "Home",
                    style: Theme.of(context).textTheme.headline1,
                  )
                ]),
          ),
        ),
      );
}
