import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salvare/database/firestore_db.dart';
import 'package:salvare/main.dart';
import 'package:salvare/view/component/appbar_widget.dart';
import 'package:salvare/view/component/profile_widget.dart';
import 'package:salvare/model/user.dart' as model;
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  DateTime selectedDate = DateTime.now();
  String? selectedName;
  String? selectedDescription;
  bool changedDOB = false;
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: buildAppBarReg(context, onPressedRegButton),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: user.photoURL ?? "https://picsum.photos/250?image=10",
            onClicked: () async {},
          ),
          const SizedBox(height: 24),
          buildNameEdit(model.User.unlaunched(
              FirebaseAuth.instance.currentUser!.uid,
              FirebaseAuth.instance.currentUser!.displayName ?? "unknown")),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
            child: Row(
              children: [
                const Text(
                  "Date Of Birth",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                IconButton(
                  onPressed: () {
                    _selectDate(context);
                  },
                  icon: const Icon(Icons.date_range, color: Colors.blue),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          buildAboutEdit(model.User.unlaunched(
              FirebaseAuth.instance.currentUser!.uid,
              FirebaseAuth.instance.currentUser!.displayName ?? "unknown")),
        ],
      ),
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

  void onPressedRegButton() async {
    model.User _user;
    if (FirebaseAuth.instance.currentUser!.displayName != null) {
      _user = model.User.unlaunched(FirebaseAuth.instance.currentUser!.uid,
          FirebaseAuth.instance.currentUser!.displayName!);
    } else {
      _user = model.User.unlaunched(
          FirebaseAuth.instance.currentUser!.uid, "unknown");
    }

    if (selectedName != null) {
      _user.userName = selectedName!;
    }
    if (changedDOB) {
      _user.dob = selectedDate;
    }
    if (selectedDescription != null) {
      _user.description = selectedDescription!;
    }

    FireStoreDB().addUserDB(_user);

    showToast(
      'Registering..',
      context: context,
      animation: StyledToastAnimation.slideFromBottom,
      curve: Curves.decelerate,
      reverseAnimation: StyledToastAnimation.fade,
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => DummyPage(),
      ),
    );
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
                  controller: TextEditingController(text: selectedName),
                  showCursor: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
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
                const Text(
                  "About",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: TextEditingController(text: selectedDescription),
                  showCursor: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
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
