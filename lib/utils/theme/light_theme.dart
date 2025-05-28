import 'package:flutter/material.dart';
import 'package:friendly_partner/utils/app_constants.dart';

ThemeData light = ThemeData(
  useMaterial3: false,
  fontFamily: AppConstants.fontFamily,
  primaryColor: const Color(0xFF40448A),
  secondaryHeaderColor: const Color(0xFF000743),
  disabledColor: const Color(0xFF000000),
  brightness: Brightness.light,
  highlightColor: Color(0xFF000000).withOpacity(0.60),
  hintColor: const Color(0xFFEEEEEE),
  cardColor: Colors.white,
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: const Color(0xFF3B9EFB))),
  colorScheme: const ColorScheme.light(
          primary: Color(0xFF3B9EFB), secondary: Color(0xFF3B9EFB))
      .copyWith(error: const Color(0xFF3B9EFB)),
);
const Color redColor = Colors.redAccent;
const Color brownColor = Color(0xff977663);
const Color greenColor = Color(0xff5BC679);
const Color greyColor = Color(0xff83A2AF);
const Color skyColor = Color(0xff46C8D0);
const Color darkBlueColor = Color(0xff517DA5);
const Color ratingYellowColor = Color(0xffff9e2c);
const Color darkPinkColor = Color(0xffBC6868);
const Color navBarColor = Color(0xffB8BBFE);
const Color profileBgColor = Color(0xffF4F5FF);
const Color primaryBlue = Color(0xff2E68D2);
const Color primaryColor = Color(0xFF40448A);