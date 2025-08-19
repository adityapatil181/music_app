import 'package:flutter/material.dart';

/// Flexible text style function
TextStyle myTextStyle({
  String fontFamily = "primary",
  Color fontColor = Colors.black,
  FontWeight fontWeight = FontWeight.normal,
  double? fontSize, // optional
  double? letterSpacing,
  double? height,
}) {
  return TextStyle(
    color: fontColor,
    fontSize: fontSize ?? 14, // default if not provided
    fontFamily: fontFamily,
    fontWeight: fontWeight,
    letterSpacing: letterSpacing,
    height: height,
  );
}

/// Predefined sizes with optional override
TextStyle myTextStyle12({Color fontColor = Colors.black, FontWeight fontWeight = FontWeight.normal, double? size}) =>
    myTextStyle(fontSize: size ?? 12, fontColor: fontColor, fontWeight: fontWeight);

TextStyle myTextStyle15({Color fontColor = Colors.black, FontWeight fontWeight = FontWeight.normal, double? size}) =>
    myTextStyle(fontSize: size ?? 15, fontColor: fontColor, fontWeight: fontWeight);

TextStyle myTextStyle18({Color fontColor = Colors.black, FontWeight fontWeight = FontWeight.normal, double? size}) =>
    myTextStyle(fontSize: size ?? 18, fontColor: fontColor, fontWeight: fontWeight);

TextStyle myTextStyle24({Color fontColor = Colors.black, FontWeight fontWeight = FontWeight.normal, double? size}) =>
    myTextStyle(fontSize: size ?? 24, fontColor: fontColor, fontWeight: fontWeight);

TextStyle myTextStyle36({Color fontColor = Colors.black, FontWeight fontWeight = FontWeight.normal, double? size}) =>
    myTextStyle(fontSize: size ?? 36, fontColor: fontColor, fontWeight: fontWeight);

TextStyle myTextStyle48({Color fontColor = Colors.black, FontWeight fontWeight = FontWeight.normal, double? size}) =>
    myTextStyle(fontSize: size ?? 48, fontColor: fontColor, fontWeight: fontWeight);
