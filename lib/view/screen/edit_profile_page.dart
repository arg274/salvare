import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:salvare/database/firestore_db.dart';
import 'package:salvare/theme/constants.dart';
import 'package:salvare/view/component/appbar_widget.dart';
import 'package:salvare/view/component/profile_widget.dart';
import 'package:salvare/model/user.dart' as model;
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  DateTime selectedDate = DateTime.now();
  String? selectedName;
  String? selectedDescription;
  bool changedDOB = false;
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
          selectedName = (snapshot.data as model.User).userName;
          selectedDescription = (snapshot.data as model.User).description;
          debugPrint("Snapshot data: ${snapshot.data}");

          child = Scaffold(
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
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                  child: Row(
                    children: [
                      Text(
                        "Date Of Birth".toUpperCase(),
                        style: Theme.of(context)
                            .textTheme
                            .formLabel
                            .fixFontFamily(),
                      ),
                      IconButton(
                        onPressed: () {
                          _selectDate(context);
                        },
                        icon: Icon(Icons.date_range,
                            color: Theme.of(context).primaryColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                snapshot.data == null
                    ? buildAboutEdit(
                        model.User.unlaunched("unknown", "unknown"))
                    : buildAboutEdit(snapshot.data as model.User)
              ],
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1970, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        changedDOB = true;
      });
    }
  }

  void onPressedSaveButton() async {
    model.User? _user = await FireStoreDB().fetchUserInfoDB();
    if (_user == null) {
      if (selectedName != null) {
        FireStoreDB().updateUserUsername(selectedName!);
      }
      if (selectedDescription != null) {
        FireStoreDB().updateUserUsername(selectedName!);
      }
    } else {
      if (selectedName != _user.userName) {
        if (selectedName != null) {
          FireStoreDB().updateUserUsername(selectedName!);
        }
      }
      if (selectedDescription != _user.description) {
        if (selectedDescription != null) {
          FireStoreDB().updateUserDescription(selectedDescription!);
        }
      }
    }
    if (changedDOB) {
      FireStoreDB().updateUserDOB(selectedDate);
    }

    showToast(
      'Saving Changes',
      context: context,
      animation: StyledToastAnimation.slideFromBottom,
      curve: Curves.decelerate,
      reverseAnimation: StyledToastAnimation.fade,
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
                Text(
                  "Display Name".toUpperCase(),
                  style: Theme.of(context).textTheme.formLabel.fixFontFamily(),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  style: Theme.of(context).textTheme.formText.fixFontFamily(),
                  controller: TextEditingController(text: selectedName),
                  maxLines: 1,
                  onChanged: (name) {
                    selectedName = name;
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
                Text(
                  "About".toUpperCase(),
                  style: Theme.of(context).textTheme.formLabel.fixFontFamily(),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  style: Theme.of(context).textTheme.formText.fixFontFamily(),
                  controller: TextEditingController(text: selectedDescription),
                  maxLines: 10,
                  onChanged: (description) {
                    selectedDescription = description;
                  },
                ),
              ],
            ),
          ),
        ],
      );
}
