import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class SalvareNavbar extends GNav {
  SalvareNavbar({Key? key})
      : super(
          key: key,
          rippleColor: Colors.teal[300]!,
          hoverColor: Colors.teal[100]!,
          gap: 8,
          activeColor: Colors.teal[500]!,
          iconSize: 24,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          duration: const Duration(milliseconds: 400),
          tabActiveBorder: Border.all(color: Colors.teal[500]!, width: 1),
          color: Colors.teal[400]!,
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
        );
}
