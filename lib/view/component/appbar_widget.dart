import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:salvare/controller/authentication.dart';
import 'package:salvare/view/screen/sign_in_screen.dart';

Route _routeToSignInScreen() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const SignInScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = const Offset(-1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

AppBar buildAppBar(BuildContext context) {
  return AppBar(
    leading: const BackButton(
      color: Colors.blue,
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
    actions: [
      IconButton(
          icon: const Icon(
            FeatherIcons.logOut,
            color: Colors.blue,
          ),
          onPressed: () async {
            Navigator.of(context).pop();
            await Authentication.signOut(context: context);
            Navigator.of(context).pushReplacement(_routeToSignInScreen());
          }),
    ],
  );
}

AppBar buildAppBarEdit(BuildContext context, Function() onPressedSaveButton) {
  return AppBar(
    leading: const BackButton(
      color: Colors.blue,
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
    actions: [
      IconButton(
        icon: const Icon(
          FeatherIcons.save,
          color: Colors.blue,
        ),
        onPressed: () {
          debugPrint("Clicked Save button");
          onPressedSaveButton();
        },
      )
    ],
  );
}

AppBar buildAppBarReg(BuildContext context, Function() onPressedRegButton) {
  return AppBar(
    leading: const BackButton(
      color: Colors.blue,
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
    actions: [
      IconButton(
        icon: const Icon(
          FeatherIcons.arrowRight,
          color: Colors.blue,
        ),
        onPressed: () {
          debugPrint("Clicked reg button");
          onPressedRegButton();
        },
      )
    ],
  );
}
