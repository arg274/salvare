import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:salvare/database/firestore_db.dart';
import 'package:salvare/theme/constants.dart';
import 'package:salvare/view/component/appbar_widget.dart';
import 'package:salvare/view/component/profile_widget.dart';
import 'package:salvare/model/user.dart' as model;
import 'package:salvare/view/screen/edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return FutureBuilder(
      future: FireStoreDB().fetchUserInfoDB(),
      builder: (context, snapshot) {
        Widget child;
        if (snapshot.hasError) {
          child = const Text('Error fetching user info from Firebase');
        } else if (snapshot.hasData) {
          debugPrint("Snapshot data: ${snapshot.data}");
          child = Scaffold(
            appBar: buildAppBar(context),
            body: Padding(
              padding: globalEdgeInsets,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        ProfileWidget(
                          imagePath: user.photoURL ??
                              "https://picsum.photos/250?image=10",
                          onClicked: () async {},
                        ),
                        Positioned.fill(
                          left: 100.0,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: FloatingActionButton(
                              mini: true,
                              heroTag: 'profileEditBtn',
                              foregroundColor: Colors.white,
                              onPressed: () =>
                                  Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const EditProfilePage(),
                                ),
                              ),
                              child: const Icon(FeatherIcons.edit2),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    snapshot.data == null
                        ? buildName(model.User.unlaunched("unknown", "unknown"))
                        : buildName(snapshot.data as model.User),
                    const SizedBox(height: 48.0),
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          snapshot.data == null
                              ? buildDOB(null)
                              : buildDOB((snapshot.data as model.User).dob),
                          rowDivider(),
                          snapshot.data == null
                              ? buildMemberSince(null)
                              : buildMemberSince(
                                  (snapshot.data as model.User).dateCreated),
                          rowDivider(),
                          snapshot.data == null
                              ? buildBucketInfo(0)
                              : buildBucketInfo((snapshot.data as model.User)
                                      .buckets
                                      ?.length ??
                                  1),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    snapshot.data == null
                        ? buildAbout(
                            model.User.unlaunched("unknown", "unknown"))
                        : buildAbout(snapshot.data as model.User),
                    const SizedBox(height: 24.0),
                  ],
                ),
              ),
            ),
          );
        } else {
          child = Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Center(
              child: SpinKitCubeGrid(
                  size: 100.0, color: Theme.of(context).primaryColor),
            ),
          );
        }
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: child,
        );
      },
    );
  }

  Widget buildName(model.User modelUser) => Column(
        children: [
          Text(
            modelUser.userName,
            style: Theme.of(context).textTheme.headline4,
          ),
          const SizedBox(height: 4),
          Text(
            FirebaseAuth.instance.currentUser!.email ?? "Unknown",
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.apply(color: Colors.grey),
          )
        ],
      );

  Widget rowDivider() => VerticalDivider(
        thickness: 2,
        indent: 5.0,
        color: Theme.of(context).primaryColor,
      );

  Widget buildAbout(model.User modelUser) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style: Theme.of(context).textTheme.headline4,
          ),
          const SizedBox(height: 16),
          Text(
            modelUser.description ?? "No User Information Available",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      );

  Widget buildBucketInfo(int totalBuckets) => Column(
        children: [
          Text(
            totalBuckets.toString(),
            style: Theme.of(context).textTheme.headline2,
          ),
          Text(
            'Bucket${(totalBuckets > 1) ? "s" : ""}'.toUpperCase(),
            style: Theme.of(context).textTheme.statLabel,
          ),
        ],
      );

  Widget buildDOB(DateTime? dob) => Column(
        children: [
          Text(
            (dob != null)
                ? (DateTime.now().difference(dob).inDays.toDouble() / 365.0)
                    .floor()
                    .toString()
                : "?",
            style: Theme.of(context).textTheme.headline2,
          ),
          Text(
            'y/o'.toUpperCase(),
            style: Theme.of(context).textTheme.statLabel,
          ),
        ],
      );

  Widget buildMemberSince(DateTime? memberSince) => Column(
        children: [
          Text(
            (memberSince != null)
                ? DateTime.now().difference(memberSince).inDays.toString() + 'D'
                : "?",
            style: Theme.of(context).textTheme.headline2,
          ),
          Text(
            'Account'.toUpperCase(),
            style: Theme.of(context).textTheme.statLabel,
          ),
          Text(
            'Age'.toUpperCase(),
            style: Theme.of(context).textTheme.statLabel,
          ),
        ],
      );
}
