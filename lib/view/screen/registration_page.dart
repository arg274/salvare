import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:salvare/database/firestore_db.dart';
import 'package:salvare/main.dart';
import 'package:salvare/theme/constants.dart';
import 'package:salvare/view/component/appbar_widget.dart';
import 'package:salvare/view/component/profile_widget.dart';
import 'package:salvare/model/user.dart' as model;

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
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
        padding: globalEdgeInsets,
        physics: const BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: user.photoURL ?? "https://picsum.photos/250?image=10",
            onClicked: () async {},
          ),
          const SizedBox(height: 24),
          Form(
            key: _formState,
            child: Column(
              children: [
                buildNameEdit(model.User.unlaunched(
                    FirebaseAuth.instance.currentUser!.uid,
                    FirebaseAuth.instance.currentUser!.displayName ??
                        "unknown")),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Text(
                      "Date Of Birth".toUpperCase(),
                      style:
                          Theme.of(context).textTheme.formLabel.fixFontFamily(),
                    ),
                    IconButton(
                      onPressed: () {
                        _selectDate(context);
                      },
                      icon: Icon(FeatherIcons.calendar,
                          color: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                buildAboutEdit(model.User.unlaunched(
                    FirebaseAuth.instance.currentUser!.uid,
                    FirebaseAuth.instance.currentUser!.displayName ??
                        "unknown")),
              ],
            ),
          ),
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
    if (_formState.currentState!.validate()) {
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

      showSalvareToast(context, 'Registering');

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const DummyPage(),
        ),
      );
    }
  }

  Widget buildNameEdit(model.User modelUser) => Column(
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
            validator: (name) => (name?.length ?? 0) < 4
                ? 'Name must be at least 4 characters'
                : null,
          ),
        ],
      );

  Widget buildAboutEdit(model.User modelUser) => Column(
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
            maxLines: 5,
            onChanged: (description) {
              selectedDescription = description;
            },
            maxLength: 256,
            validator: (desc) =>
                (desc?.length ?? 0) > 256 ? 'Description too long' : null,
          ),
        ],
      );
}
