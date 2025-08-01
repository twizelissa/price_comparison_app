import 'package:flutter/material.dart';

class ResponsiveLayout {
  static bool isPortrait(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.portrait;

  static bool isLandscape(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double responsiveFontSize(BuildContext context, 
      {double portraitSize = 16, double landscapeSize = 14}) {
    return isPortrait(context) ? portraitSize : landscapeSize;
  }

  static EdgeInsets responsivePadding(BuildContext context, 
      {EdgeInsets? portraitPadding, EdgeInsets? landscapePadding}) {
    final defaultPortrait = EdgeInsets.all(16.0);
    final defaultLandscape = EdgeInsets.all(8.0);
    
    return isPortrait(context) 
        ? portraitPadding ?? defaultPortrait
        : landscapePadding ?? defaultLandscape;
  }

  // Add this new method to get the current orientation
  static Orientation getOrientation(BuildContext context) {
    return MediaQuery.of(context).orientation;
  }
}