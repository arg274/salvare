import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:patterns_canvas/patterns_canvas.dart';

EdgeInsets globalEdgeInsets = const EdgeInsets.symmetric(horizontal: 20.0);
var primarySwatch = Colors.teal;
var primaryColor = primarySwatch[200]!;
var primaryColorLight = primarySwatch[100]!;
var primaryColorDark = primarySwatch[400]!;

Future<Object?> showBlurredDialog(
    {required BuildContext context, required AlertDialog dialogBody}) {
  return showGeneralDialog(
      context: context,
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(0.35),
      barrierDismissible: true,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) => dialogBody,
      transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: 10 * anim1.value, sigmaY: 10 * anim1.value),
            child: FadeTransition(
              child: child,
              opacity: anim1,
            ),
          ));
}

TextTheme textTheme = const TextTheme(
  headline1: TextStyle(fontSize: 48.0, fontWeight: FontWeight.w900),
  headline4: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w900),
  bodyText1: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
  headline6: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
).fixFontFamily();

class RandomPatternGenerator extends CustomPainter {
  Random random = Random();
  Color getRandomLightColour() {
    return Colors.primaries[random.nextInt(Colors.primaries.length)]
        [(Random().nextInt(3) + 1) * 100]!;
  }

  Color getRandomDarkColour() {
    return Colors.primaries[random.nextInt(Colors.primaries.length)]
        [(Random().nextInt(6) + 4) * 100]!;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Pattern.fromValues(
      patternType:
          PatternType.values[random.nextInt(PatternType.values.length)],
      bgColor: primaryColorDark,
      fgColor: primaryColorLight,
    ).paintOnWidget(canvas, size);
  }

  //TODO: Fix constant redraws
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

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
      fontWeight: FontWeight.w300,
    );
  }

  TextStyle get formLabel {
    return navLabel.copyWith(letterSpacing: 2.0);
  }

  TextStyle get buttonText {
    return navLabel;
  }

  TextStyle get chipText {
    return const TextStyle(
      fontSize: 12.0,
      color: Colors.white,
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
    inputDecorationTheme: InputDecorationTheme(
      border:
          UnderlineInputBorder(borderSide: BorderSide(color: primaryColorDark)),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: primaryColorDark)),
      errorBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.red[200]!)),
      focusedErrorBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.red[200]!)),
    ),
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
    scaffoldBackgroundColor: Colors.black,
    brightness: Brightness.dark,
    disabledColor: Colors.grey[200],
    shadowColor: Colors.grey[600],
    canvasColor: Colors.black,
    textTheme: textTheme.apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ));
