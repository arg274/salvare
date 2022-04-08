import 'package:flutter/material.dart';

EdgeInsets globalEdgeInsets = const EdgeInsets.symmetric(horizontal: 20.0);
var primarySwatch = Colors.teal;
var primaryColor = Colors.teal[200]!;
var primaryColorLight = Colors.teal[100]!;

TextTheme textTheme = const TextTheme(
  headline1: TextStyle(fontSize: 48.0, fontWeight: FontWeight.w900),
  bodyText1: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
  headline6: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
).fixFontFamily();

extension CustomStyles on TextTheme {
  TextStyle get navLabel {
    return TextStyle(
      fontSize: 14.0,
      color: lightTheme.primaryColor,
      fontWeight: FontWeight.w400,
    );
  }

  TextStyle get domainText {
    return const TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.w200,
    );
  }

  TextStyle get formLabel {
    return navLabel;
  }

  TextStyle get buttonText {
    return navLabel;
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
    primarySwatch: primarySwatch,
    primaryColor: primaryColor,
    primaryColorLight: primaryColorLight,
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
    disabledColor: Colors.grey[600],
    shadowColor: Colors.grey[400],
    textTheme: textTheme.apply(
      bodyColor: Colors.black,
      displayColor: Colors.black,
    ));

ThemeData darkTheme = lightTheme.copyWith(
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[200]!)),
      errorBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.red[200]!)),
      focusedErrorBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.red[200]!)),
    ),
    scaffoldBackgroundColor: Colors.black,
    brightness: Brightness.dark,
    disabledColor: Colors.grey[200],
    shadowColor: Colors.grey[600],
    canvasColor: Colors.black,
    textTheme: textTheme.apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ));
