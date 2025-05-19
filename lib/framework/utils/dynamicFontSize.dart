import 'package:flutter/material.dart';


  double getResponsiveFontSize(BuildContext context, double baseFontSize) {
    double scaleFactor = MediaQuery.of(context).textScaleFactor;
    double screenWidth = MediaQuery.of(context).size.width;
    return (baseFontSize * (screenWidth / 375)) * scaleFactor;
  }


  String formatAddress(String address) {
    if (address.length > 10) {
      return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
    }
    return address;
  }
