import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:salvare/view/dashboard.dart';
import 'package:salvare/view/search.dart';
import 'package:salvare/view/settings.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:salvare/theme/constants.dart';

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
      home: const DummyPage(),
    );
  }
}

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
    const Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
