import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:salvare/controller/authentication.dart';
import 'package:salvare/res/custom_colors.dart';
import 'package:salvare/view/screen/dashboard.dart';
import 'package:salvare/view/screen/search.dart';
import 'package:salvare/view/screen/settings.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:salvare/theme/constants.dart';
import 'package:salvare/view/screen/sign_in_screen.dart';

void main() {
  runApp(const Salvare());
}

class Salvare extends StatelessWidget {
  const Salvare({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salvare',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
      home: SignInScreen(),
    );
  }
}

// Dummy page
class DummyPage extends StatefulWidget {
  const DummyPage({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  State<DummyPage> createState() => _DummyPageState();
}

class _DummyPageState extends State<DummyPage> {
  late User _user;
  bool _isSigningOut = false;

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SignInScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  int screenIndex = 0;
  final screens = [
    const Dashboard(),
    const Search(),
    const Settings(),
  ];

  @override
  void initState() {
    _user = widget._user;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
        floatingActionButton: FloatingActionButton(
          heroTag: "btn1",
          child: const Icon(FeatherIcons.logOut),
          backgroundColor: CustomColors.salvareDarkGreen,
          onPressed: () async {
            setState(() {
              _isSigningOut = true;
            });
            await Authentication.signOut(context: context);
            setState(() {
              _isSigningOut = false;
            });
            Navigator.of(context).pushReplacement(_routeToSignInScreen());
          },
        ),
        body: IndexedStack(
          index: screenIndex,
          children: screens,
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Theme.of(context).primaryColorLight,
              gap: 8,
              activeColor: Theme.of(context).primaryColor,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 200),
              tabActiveBorder:
                  Border.all(color: Theme.of(context).primaryColor, width: 1),
              color: Theme.of(context).primaryColor,
              textStyle: Theme.of(context).textTheme.navlabel.fixFontFamily(),
              // ignore: prefer_const_literals_to_create_immutables
              tabs: [
                const GButton(
                  icon: FeatherIcons.home,
                  text: 'Home',
                ),
                const GButton(
                  icon: FeatherIcons.search,
                  text: 'Search',
                ),
                const GButton(
                  icon: FeatherIcons.settings,
                  text: 'Settings',
                ),
              ],
              selectedIndex: screenIndex,
              onTabChange: (index) {
                setState(() {
                  screenIndex = index;
                });
              },
            ),
          ),
        ));
  }
}
