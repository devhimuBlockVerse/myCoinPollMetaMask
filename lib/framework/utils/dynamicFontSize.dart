import 'package:flutter/material.dart';


  double getResponsiveFontSize(BuildContext context, double baseFontSize) {
    double scaleFactor = MediaQuery.of(context).textScaleFactor;
    double screenWidth = MediaQuery.of(context).size.width;
    return (baseFontSize * (screenWidth / 375)) * scaleFactor;
  }

