import 'package:flutter/material.dart';

EdgeInsets globalEdgeInsets = const EdgeInsets.symmetric(horizontal: 20.0);

TextTheme textTheme = const TextTheme(
  headline1: TextStyle(fontSize: 48.0, fontWeight: FontWeight.w900),
  bodyText1: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
).fixFontFamily();

extension CustomStyles on TextTheme {
  TextStyle get navlabel {
    return TextStyle(
      fontSize: 14.0,
      color: lightTheme.primaryColor,
      fontWeight: FontWeight.w400,
    );
  }

  TextTheme fixFontFamily() {
    return apply(fontFamily: 'Inter');
  }
}

extension FontFix on TextStyle {
  TextStyle fixFontFamily() {
    return apply(fontFamily: 'Inter');
  }
}

ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.teal,
    primaryColor: Colors.teal[200]!,
    primaryColorLight: Colors.teal[100]!,
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
    textTheme: textTheme.apply(
      bodyColor: Colors.black,
      displayColor: Colors.black,
    ));

ThemeData darkTheme = lightTheme.copyWith(
    scaffoldBackgroundColor: Colors.black,
    brightness: Brightness.dark,
    textTheme: textTheme.apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ));
