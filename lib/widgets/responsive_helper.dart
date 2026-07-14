import 'package:flutter/material.dart';

class ResponsiveHelper {
  static bool isSmallScreen(BuildContext context) =>
      MediaQuery.of(context).size.width < 360;

  static bool isMediumScreen(BuildContext context) =>
      MediaQuery.of(context).size.width >= 360 &&
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 900;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 900;

  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static int gridColumns(BuildContext context) {
    if (isTablet(context)) return 2;
    if (isDesktop(context)) return 3;
    return 1;
  }
}
