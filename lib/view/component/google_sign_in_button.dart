import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:salvare/controller/authentication.dart';
import 'package:salvare/database/firestore_db.dart';
import 'package:salvare/main.dart';
import 'package:salvare/theme/constants.dart';
import 'package:salvare/model/user.dart' as model;
import 'package:salvare/view/screen/registration_page.dart';

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({Key? key}) : super(key: key);

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return _isSigningIn
        ? const SpinKitCubeGrid(size: 50.0, color: Colors.white)
        : OutlinedButton(
            style: ButtonStyle(
              side: MaterialStateProperty.all(const BorderSide(
                color: Colors.white,
                width: 2.5,
              )),
              backgroundColor: MaterialStateProperty.all(Colors.transparent),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            ),
            onPressed: () async {
              setState(() {
                _isSigningIn = true;
              });
              User? user =
                  await Authentication.signInWithGoogle(context: context);

              setState(() {
                _isSigningIn = false;
              });

              if (user != null) {
                model.User? _user = await FireStoreDB().fetchUserInfoDB();
                if (_user == null) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const RegistrationPage(),
                    ),
                  );
                } else {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const DummyPage(),
                    ),
                  );
                }
              }
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const ColorFiltered(
                    colorFilter:
                        ColorFilter.mode(Colors.white, BlendMode.srcATop),
                    child: Image(
                      image: AssetImage("assets/google_logo.png"),
                      height: 25.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'Enter'.toUpperCase(),
                      style: Theme.of(context).textTheme.formLabel.apply(
                            color: Colors.white,
                          ),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
