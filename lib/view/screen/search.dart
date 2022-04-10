import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:salvare/res/custom_colors.dart';
import 'package:salvare/controller/bucket_controller.dart';

class Search extends StatelessWidget {
  const Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(child: Text('Search')),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
        floatingActionButton: FloatingActionButton(
          heroTag: "btn99",
          child: const Icon(FeatherIcons.award),
          backgroundColor: CustomColors.salvareDarkGreen,
          onPressed: () {
            BucketController().addBucketDummy();
            BucketController().addUserToBucketDummy();
          },
        ),
      );
}
