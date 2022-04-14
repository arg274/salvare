import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:salvare/database/firestore_db.dart';
import 'package:salvare/model/user.dart' as model_user;
import 'package:salvare/res/custom_colors.dart';
import 'package:salvare/view/screen/dashboard.dart';
import 'package:salvare/view/screen/profile_page.dart';
import 'package:salvare/view/screen/search.dart';
import 'package:salvare/view/screen/buckets.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:salvare/theme/constants.dart';
import 'package:salvare/view/screen/sign_in_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Salvare());
}

class Salvare extends StatelessWidget {
  final Future<FirebaseApp> _firebaseApp = Firebase.initializeApp();
  Salvare({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salvare',
      theme: lightTheme,
      darkTheme: darkTheme,
      // TODO: Change theme in setting?
      themeMode: ThemeMode.light,
      home: FutureBuilder(
        future: _firebaseApp,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            debugPrint("Error! ${snapshot.error.toString()}");
            return const Text("Something Went Wrong");
          } else if (snapshot.hasData) {
            debugPrint("Firebase Initialization successfull");
            return const SignInScreen();
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

// Dummy page
class DummyPage extends StatefulWidget {
  const DummyPage({Key? key}) : super(key: key);

  @override
  State<DummyPage> createState() => _DummyPageState();
}

class _DummyPageState extends State<DummyPage> {
  int screenIndex = 0;
  final screens = [
    const Dashboard(),
    const Search(),
    const Buckets(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness:
            (Theme.of(context).brightness == Brightness.dark)
                ? Brightness.light
                : Brightness.dark,
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
          floatingActionButton: FloatingActionButton(
            heroTag: "btn1",
            child: const Icon(FeatherIcons.user),
            backgroundColor: CustomColors.salvareDarkGreen,
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
          body: SafeArea(
            child: IndexedStack(
              index: screenIndex,
              children: screens,
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: GNav(
                rippleColor: Theme.of(context).primaryColorLight,
                haptic: true,
                gap: 8,
                activeColor: Theme.of(context).primaryColor,
                iconSize: 24,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: const Duration(milliseconds: 200),
                tabActiveBorder:
                    Border.all(color: Theme.of(context).primaryColor, width: 1),
                color: Theme.of(context).primaryColor,
                textStyle: Theme.of(context).textTheme.navLabel.fixFontFamily(),
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
                    icon: FeatherIcons.shoppingBag,
                    text: 'Buckets',
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
          )),
    );
  }
}
