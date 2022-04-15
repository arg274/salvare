import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:salvare/controller/authentication.dart';
import 'package:salvare/theme/constants.dart';
import 'package:salvare/view/component/google_sign_in_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: Padding(
            padding: globalEdgeInsets,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ColorFiltered(
                        child: Image.asset(
                          'assets/start.png',
                        ),
                        colorFilter: ColorFilter.mode(
                            Theme.of(context).primaryColor, BlendMode.color),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Welcome to Salvare!',
                        style: Theme.of(context)
                            .textTheme
                            .headline2!
                            .apply(color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Please log in or sign up using your Google account to continue.',
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .apply(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 100.0),
                  child: FutureBuilder(
                    future: Authentication.initializeFirebase(context: context),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Error initializing Firebase');
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        return const GoogleSignInButton();
                      }
                      return const SpinKitCubeGrid(
                          size: 50.0, color: Colors.white);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
