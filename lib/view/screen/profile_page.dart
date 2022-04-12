import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salvare/database/firestore_db.dart';
import 'package:salvare/res/custom_colors.dart';
import 'package:salvare/view/component/appbar_widget.dart';
import 'package:salvare/view/component/button_widget.dart';
import 'package:salvare/view/component/profile_widget.dart';
import 'package:salvare/model/user.dart' as model;

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
                const SizedBox(height: 24),
                buildName(user),
                const SizedBox(height: 24),
                Center(child: buildEditButton()),
                const SizedBox(height: 48),
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

  Widget buildName(User user) => Column(
        children: [
          Text(
            user.displayName ?? "Unknown",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            user.email ?? "Unknown",
            style: const TextStyle(color: Colors.grey),
          )
        ],
      );

  Widget buildEditButton() => ButtonWidget(
        text: 'Edit Profile',
        onClicked: () {
          // TODO: Edit profile functionalities
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
}
