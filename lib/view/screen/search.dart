import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:salvare/database/firestore_db.dart';
import 'package:salvare/model/bucket.dart';
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
            //BucketController().addBucketDummy();
            //BucketController().addUserToBucketDummy();
            //BucketController().addResourceToBucketDummy();
            //BucketController().fetchBucketResourcesDummy();
            //FireStoreDB().deleteBucketDB("098b4cc0d9072345f5ab02050da52469");
          },
        ),
      );
}
