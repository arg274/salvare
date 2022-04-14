import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:patterns_canvas/patterns_canvas.dart';

EdgeInsets globalEdgeInsets = const EdgeInsets.symmetric(horizontal: 20.0);
EdgeInsets cardListEdgeInsets =
    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0);
var primarySwatch = Colors.teal;
var primaryColor = primarySwatch[200]!;
var primaryColorLight = primarySwatch[100]!;
var primaryColorDark = primarySwatch[400]!;

ColorFilter tintMatrix({
  Color tintColor = Colors.grey,
  double scale = 1,
}) {
  final int r = tintColor.red;
  final int g = tintColor.green;
  final int b = tintColor.blue;

  final double rTint = r / 255;
  final double gTint = g / 255;
  final double bTint = b / 255;

  const double rL = 0.2126;
  const double gL = 0.7152;
  const double bL = 0.0722;

  final double translate = 1 - scale * 0.5;

  return ColorFilter.matrix(<double>[
    (rL * rTint * scale),
    (gL * rTint * scale),
    (bL * rTint * scale),
    (0),
    (r * translate),
    (rL * gTint * scale),
    (gL * gTint * scale),
    (bL * gTint * scale),
    (0),
    (g * translate),
    (rL * bTint * scale),
    (gL * bTint * scale),
    (bL * bTint * scale),
    (0),
    (b * translate),
    (0),
    (0),
    (0),
    (1),
    (0),
  ]);
}

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
  headline2: TextStyle(fontSize: 40.0, fontWeight: FontWeight.w900),
  headline3: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w900),
  headline4: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w900),
  bodyText1: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
  headline6: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
).fixFontFamily();

class RandomPatternGenerator extends CustomPainter {
  final Random random = Random();
  final PatternType pattern =
      PatternType.values[Random().nextInt(PatternType.values.length)];

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
      patternType: pattern,
      bgColor: primaryColorDark,
      fgColor: primaryColorLight,
    ).paintOnWidget(canvas, size);
  }

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

  TextStyle get formText {
    return textTheme.bodyText1!;
  }

  TextStyle get statLabel {
    return textTheme.headline6!.copyWith(letterSpacing: 2.0);
  }

  TextStyle get buttonText {
    return navLabel;
  }

  TextStyle get fillButtonText {
    return const TextStyle(
      fontSize: 14.0,
      color: Colors.white,
    );
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
    cardColor: Colors.white,
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
    cardColor: Colors.black87,
    textTheme: textTheme.apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ));
