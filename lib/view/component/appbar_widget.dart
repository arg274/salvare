import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarIconBrightness: (Theme.of(context).brightness == Brightness.dark)
          ? Brightness.light
          : Brightness.dark,
      statusBarColor: Colors.transparent,
    ),
    leading: BackButton(
      color: Theme.of(context).primaryColor,
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
    actions: [
      IconButton(
          icon: Icon(
            FeatherIcons.logOut,
            color: Theme.of(context).primaryColor,
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
    leading: BackButton(
      color: Theme.of(context).primaryColor,
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
    actions: [
      IconButton(
        icon: Icon(
          FeatherIcons.save,
          color: Theme.of(context).primaryColor,
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
    leading: BackButton(
      color: Theme.of(context).primaryColor,
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
    actions: [
      IconButton(
        icon: Icon(
          FeatherIcons.arrowRight,
          color: Theme.of(context).primaryColor,
        ),
        onPressed: () {
          debugPrint("Clicked reg button");
          onPressedRegButton();
        },
      )
    ],
  );
}
