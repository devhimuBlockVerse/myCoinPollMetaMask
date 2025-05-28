import 'package:flutter/material.dart';

import '../res/colors.dart';
import 'dynamicFontSize.dart';

class AppTextStyles {
  static const String _fontFamily = 'Poppins';



  static TextStyle  cardTitle(BuildContext context) {
    return  TextStyle(
      fontFamily: _fontFamily,
      color: AppColors.textPrimary,
      fontSize: getResponsiveFontSize(context,16),
      fontWeight: FontWeight.w500,
      height: 1.3,
    );
  }

  static TextStyle cardSubtitle(BuildContext context) {
    return  TextStyle(
      fontFamily: _fontFamily,
      color: AppColors.textPrimary,
      fontSize: getResponsiveFontSize(context,12),
      fontWeight: FontWeight.w400,
      height: 0.8,


    );
  }

  static TextStyle rewardText (BuildContext context){
    return  TextStyle(
      fontFamily: _fontFamily,
      color: AppColors.accentGreen,
      fontWeight: FontWeight.w400,
      height: 0.8,
      fontSize: getResponsiveFontSize(context,12),

    );
  }

  static TextStyle get rewardSecondaryText {
    return const TextStyle(
      fontFamily: _fontFamily,
      color: AppColors.accentGreen,
      fontSize: 13, // Adjust based on Figma
      fontWeight: FontWeight.normal,
    );
  }

  static TextStyle get buttonText {
    return const TextStyle(
      fontFamily: _fontFamily,
      color: Colors.white,
      fontSize: 14, // Adjust based on Figma
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle get statusBadgeText {
    return const TextStyle(
      fontFamily: _fontFamily,
      color: Colors.white,
      fontSize: 10,
      fontWeight: FontWeight.w500,
      height: 1.3,

    );
  }

  static TextStyle milestoneText(BuildContext context) {
    return TextStyle(
        fontFamily: _fontFamily,
        color: AppColors.textSecondary,
        fontSize: getResponsiveFontSize(context,12),
        height: 1.3,
        fontStyle: FontStyle.italic
    );
  }
}