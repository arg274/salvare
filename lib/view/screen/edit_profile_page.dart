import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:salvare/database/firestore_db.dart';
import 'package:salvare/main.dart';
import 'package:salvare/theme/constants.dart';
import 'package:salvare/view/component/appbar_widget.dart';
import 'package:salvare/view/component/profile_widget.dart';
import 'package:salvare/model/user.dart' as model;
import 'package:salvare/view/screen/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:switcher_button/switcher_button.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
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
              padding: globalEdgeInsets,
              physics: const BouncingScrollPhysics(),
              children: [
                ProfileWidget(
                  imagePath:
                      user.photoURL ?? "https://picsum.photos/250?image=10",
                  onClicked: () async {},
                ),
                const SizedBox(height: 24),
                Form(
                  key: _formState,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      snapshot.data == null
                          ? buildNameEdit(
                              model.User.unlaunched("unknown", "unknown"))
                          : buildNameEdit(snapshot.data as model.User),
                      const SizedBox(height: 24),
                      Row(
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
                            icon: Icon(FeatherIcons.calendar,
                                color: Theme.of(context).primaryColor),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      snapshot.data == null
                          ? buildAboutEdit(
                              model.User.unlaunched("unknown", "unknown"))
                          : buildAboutEdit(snapshot.data as model.User),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                buildDarkModeSwitch(),
                const SizedBox(height: 24),
                buildColorPicker(),
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
    if (_formState.currentState!.validate()) {
      showSalvareToast(context, 'Saving changes');

      model.User? _user = await FireStoreDB().fetchUserInfoDB();
      if (_user == null) {
        if (selectedName != null) {
          await FireStoreDB().updateUserUsername(selectedName!);
        }
        if (selectedDescription != null) {
          await FireStoreDB().updateUserDescription(selectedDescription!);
        }
      } else {
        if (selectedName != _user.userName) {
          if (selectedName != null) {
            await FireStoreDB().updateUserUsername(selectedName!);
          }
        }
        if (selectedDescription != _user.description) {
          if (selectedDescription != null) {
            await FireStoreDB().updateUserDescription(selectedDescription!);
          }
        }
      }
      if (changedDOB) {
        await FireStoreDB().updateUserDOB(selectedDate);
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ProfilePage(),
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

  Widget buildColorPicker() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Accent".toUpperCase(),
            style: Theme.of(context).textTheme.formLabel.fixFontFamily(),
          ),
          const SizedBox(height: 8),
          FutureBuilder<SharedPreferences>(
              future: SharedPreferences.getInstance(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.getString('accent') == null) {
                    snapshot.data!.setString('accent', 'teal');
                  }
                  return MaterialColorPicker(
                    allowShades: false,
                    onMainColorChange: (value) async {
                      debugPrint(value.toString());
                      snapshot.data!.setString(
                          'accent', swatchReverseLookupTable[value] ?? 'teal');
                      await DynamicColorTheme.create();
                      Salvare.notifier.value =
                          DynamicColorTheme.getInstance().dayNightTheme();
                    },
                    selectedColor: swatchLookupTable[
                        snapshot.data!.getString('accent') ?? 'teal'],
                    colors: swatchReverseLookupTable.keys.toList(),
                  );
                } else if (snapshot.hasError) {
                  // TODO: Error handling
                  return Text('${snapshot.error}');
                } else {
                  // TODO: Progress indicator
                  return const Text('Loading...');
                }
              }),
        ],
      );

  Widget buildDarkModeSwitch() => FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.getBool('darkMode') == null) {
            snapshot.data!.setBool('darkMode', false);
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Dark Mode".toUpperCase(),
                style: Theme.of(context).textTheme.formLabel.fixFontFamily(),
              ),
              const SizedBox(width: 10.0),
              SwitcherButton(
                value: snapshot.data!.getBool('darkMode') ?? false,
                offColor: Theme.of(context).primaryColorLight,
                onColor: Theme.of(context).primaryColorDark,
                onChange: (value) async {
                  snapshot.data!.setBool('darkMode', value);
                  await DynamicColorTheme.create();
                  Salvare.notifier.value =
                      DynamicColorTheme.getInstance().dayNightTheme();
                },
              ),
            ],
          );
        } else if (snapshot.hasError) {
          // TODO: Error handling
          return Text('${snapshot.error}');
        } else {
          // TODO: Progress indicator
          return const Text('Loading...');
        }
      });
}
