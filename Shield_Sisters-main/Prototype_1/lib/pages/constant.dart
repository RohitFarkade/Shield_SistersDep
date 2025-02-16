import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:iconly/iconly.dart';
import 'package:flutter/widgets.dart';
import '/pages/BottomNavigation.dart';

//

double animatedPositionedLEftValue(int currentIndex) {
  switch (currentIndex) {
    case 0:
      return AppSizes.blockSizeHorizontal * 5.5;
    case 1:
      return AppSizes.blockSizeHorizontal * 22.5;
    case 2:
      return AppSizes.blockSizeHorizontal * 39.5;
    case 3:
      return AppSizes.blockSizeHorizontal * 56.5;
    case 4:
      return AppSizes.blockSizeHorizontal * 73.5;
    default:
      return 0;
  }
}


final List<Color> gradient = [
  Color(0xFFC8DCD3).withOpacity(0.8),
  Color(0xFFD0E6DC).withOpacity(0.5),
  Colors.transparent
];