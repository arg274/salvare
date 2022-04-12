import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salvare/database/firestore_db.dart';
import 'package:salvare/res/custom_colors.dart';
import 'package:salvare/view/component/appbar_widget.dart';
import 'package:salvare/view/component/button_widget.dart';
import 'package:salvare/view/component/profile_widget.dart';
import 'package:salvare/model/user.dart' as model;
import 'package:intl/intl.dart';
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
        if (snapshot.hasError) {
          return const Text('Error fetching user info from Firebase');
        } else if (snapshot.hasData) {
          debugPrint("Snapshot data: ${snapshot.data}");
          return Scaffold(
            appBar: buildAppBar(context),
            body: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                ProfileWidget(
                  imagePath:
                      user.photoURL ?? "https://picsum.photos/250?image=10",
                  onClicked: () async {},
                ),
                const SizedBox(height: 16),
                snapshot.data == null
                    ? buildName(model.User.unlaunched("unknown", "unknown"))
                    : buildName(snapshot.data as model.User),
                const SizedBox(height: 16),
                Center(child: buildEditButton()),
                const SizedBox(height: 48),
                snapshot.data == null
                    ? buildDOB("Unknown")
                    : (snapshot.data as model.User).dob == null
                        ? buildDOB("Unknown")
                        : buildDOB(DateFormat('dd/MM/yyyy')
                            .format((snapshot.data as model.User).dob!)),
                const SizedBox(height: 16),
                snapshot.data == null
                    ? buildBucketInfo(0)
                    : buildBucketInfo(
                        (snapshot.data as model.User).buckets?.length ?? 1),
                const SizedBox(height: 16),
                snapshot.data == null
                    ? buildAbout(model.User.unlaunched("unknown", "unknown"))
                    : buildAbout(snapshot.data as model.User)
              ],
            ),
          );
        } else {
          return CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          );
        }
      },
    );
  }

  Widget buildName(model.User modelUser) => Column(
        children: [
          Text(
            modelUser.userName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            FirebaseAuth.instance.currentUser!.email ?? "Unknown",
            style: const TextStyle(color: Colors.grey),
          )
        ],
      );

  Route _routeToUserEditProfileScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const EditProfilePage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Widget buildEditButton() => ButtonWidget(
        text: 'Edit Profile',
        onClicked: () {
          // TODO: Edit profile functionalities
          Navigator.of(context)
              .pushReplacement(_routeToUserEditProfileScreen());
        },
      );

  Widget buildAbout(model.User modelUser) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              modelUser.description ?? "No User Information Available",
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );

  Widget buildBucketInfo(int total_buckets) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Buckets:  $total_buckets',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );

  Widget buildDOB(String data) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date of Birth:  $data',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
}
