import 'package:flutter/material.dart';
import 'package:krishanthmart_new/utils/colors.dart';

ThemeData theme() {
  return ThemeData(
    scaffoldBackgroundColor: MyTheme.PrimaryLightColor,
    fontFamily: 'PublicSansSerif',
    textTheme: textTheme(),
    inputDecorationTheme: inputDecorationTheme(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primaryColor: MyTheme.PrimaryLightColor,
  );
}

InputDecorationTheme inputDecorationTheme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(20.0),
    borderSide: const BorderSide(width: 3, color: MyTheme.SecondaryColorDark),
    gapPadding: 10,
  );

  OutlineInputBorder outlineInputErrorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(20.0),
    borderSide: const BorderSide(width: 3, color: Color(0xffea4b4b)),
    gapPadding: 10,
  );
  return InputDecorationTheme(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.symmetric(horizontal: 42, vertical: 20),
      enabledBorder: outlineInputBorder,
      focusedBorder: outlineInputBorder,
      border: outlineInputBorder,
      errorStyle: const TextStyle(height: 0),
      errorBorder: outlineInputErrorBorder);
}

TextTheme textTheme() {
  return const TextTheme(
    bodyLarge: TextStyle(color: MyTheme.SecondaryColorDark),
    bodyMedium: TextStyle(color: MyTheme.SecondaryColorDark),
  );
}
