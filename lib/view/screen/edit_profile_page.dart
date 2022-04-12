import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salvare/database/firestore_db.dart';
import 'package:salvare/res/custom_colors.dart';
import 'package:salvare/view/component/appbar_widget.dart';
import 'package:salvare/view/component/button_widget.dart';
import 'package:salvare/view/component/profile_widget.dart';
import 'package:salvare/model/user.dart' as model;
import 'package:salvare/view/component/textfield_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String? selected_name;
  String? selected_description;
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return FutureBuilder(
      future: FireStoreDB().fetchUserInfoDB(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error fetching user info from Firebase');
        } else if (snapshot.hasData) {
          selected_name = (snapshot.data as model.User).userName;
          selected_description = (snapshot.data as model.User).description;
          debugPrint("Snapshot data: ${snapshot.data}");

          return Scaffold(
            appBar: buildAppBarEdit(context, onPressedSaveButton),
            body: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                ProfileWidget(
                  imagePath:
                      user.photoURL ?? "https://picsum.photos/250?image=10",
                  onClicked: () async {},
                ),
                const SizedBox(height: 24),
                snapshot.data == null
                    ? buildNameEdit(model.User.unlaunched("unknown", "unknown"))
                    : buildNameEdit(snapshot.data as model.User),
                const SizedBox(height: 48),
                snapshot.data == null
                    ? buildAboutEdit(
                        model.User.unlaunched("unknown", "unknown"))
                    : buildAboutEdit(snapshot.data as model.User)
              ],
            ),
          );
        } else {
          return const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          );
        }
      },
    );
  }

  void onPressedSaveButton() async {
    model.User? _user = await FireStoreDB().fetchUserInfoDB();
    if (_user == null) {
      if (selected_name != null) {
        FireStoreDB().updateUserUsername(selected_name!);
      }
      if (selected_description != null) {
        FireStoreDB().updateUserUsername(selected_name!);
      }
    } else {
      if (selected_name != _user.userName) {
        if (selected_name != null) {
          FireStoreDB().updateUserUsername(selected_name!);
        }
      }
      if (selected_description != _user.description) {
        if (selected_description != null) {
          FireStoreDB().updateUserDescription(selected_description!);
        }
      }
    }

    Fluttertoast.showToast(
        msg: "Saving Profile Info", //message to show toast
        toastLength: Toast.LENGTH_LONG, //duration for message to show
        gravity: ToastGravity.CENTER, //where you want to show, top, bottom
        fontSize: 16.0 //message font size
        );

    Navigator.of(context).pop();
  }

  Widget buildNameEdit(model.User modelUser) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Display Name",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: TextEditingController(text: selected_name),
                  showCursor: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLines: 1,
                  onChanged: (name) {
                    selected_name = name;
                  },
                ),
              ],
            ),
          ),
        ],
      );

  Widget buildAboutEdit(model.User modelUser) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "About",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: TextEditingController(text: selected_description),
                  showCursor: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLines: 10,
                  onChanged: (description) {
                    selected_description = description;
                  },
                ),
              ],
            ),
          ),
        ],
      );
}
