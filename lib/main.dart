import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:salvare/view/screen/dashboard.dart';
import 'package:salvare/view/screen/search.dart';
import 'package:salvare/view/screen/buckets.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:salvare/theme/constants.dart';
import 'package:salvare/view/screen/sign_in_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DynamicColorTheme.create();
  runApp(Salvare());
}

class Salvare extends StatelessWidget {
  static ValueNotifier<ThemeData> notifier =
      ValueNotifier(DynamicColorTheme.getInstance().dayNightTheme());
  final Future<FirebaseApp> _firebaseApp = Firebase.initializeApp();
  Salvare({Key? key}) : super(key: key);

  static void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeData>(
        valueListenable: notifier,
        builder: (_, theme, __) {
          return MaterialApp(
            title: 'Salvare',
            theme: theme,
            darkTheme: DynamicColorTheme.getInstance().darkTheme(),
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
        });
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
