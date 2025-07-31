import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfileOptionContainer extends StatelessWidget {
  final String labelText;
  final Color? labelTextColor;
  final Color? iconColor;
  final String leadingIconPath;
  final String trailingIconPath;
  final VoidCallback? onTrailingIconTap;

  const ProfileOptionContainer({
    super.key,
    required this.labelText,
    required this.leadingIconPath,
    required this.trailingIconPath,
    this.onTrailingIconTap,
    this.labelTextColor, this.iconColor ,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = screenWidth / 375;
    final Color textColor = labelTextColor ?? const Color(0xffFFF5ED).withOpacity(0.8);
    final Color leadingIconColor = iconColor ?? Colors.white.withOpacity(0.8);
    final Color trailingIconColor = iconColor ?? Colors.white.withOpacity(0.3);

    return GestureDetector(
      onTap: onTrailingIconTap,
      child: Container(
        width: screenWidth * 0.82,
        height: 42 * scaleFactor,
        padding: EdgeInsets.symmetric(
          horizontal: 20 * scaleFactor,
        ),
        decoration: ShapeDecoration(
          color: const Color(0xFF12161D),
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xFF141317)),
            borderRadius: BorderRadius.circular(8 * scaleFactor),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            /// Leading Icon
            Center(
              child: SvgPicture.asset(
                leadingIconPath,
                width: 20 * scaleFactor,
                height: 20 * scaleFactor,
                color: leadingIconColor
              ),
            ),

            SizedBox(width: 12 * scaleFactor),

            /// Label Text
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  labelText,
                  style: TextStyle(
                    color:textColor ,
                    fontSize: 14 * scaleFactor,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                  ),
                ),
              ),
            ),

            /// Trailing Icon
            Center(
              child: SvgPicture.asset(
                trailingIconPath,
                width: 10 * scaleFactor,
                height: 10 * scaleFactor,
                color: trailingIconColor
              ),
            ),
          ],
        ),
      ),
    );
  }
}
