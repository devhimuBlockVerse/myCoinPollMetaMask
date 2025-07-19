import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/dynamicFontSize.dart';
class WalletAddressComponent extends StatelessWidget {
  final String address;
 final VoidCallback? onTap;
  const WalletAddressComponent({
    super.key,
    required this.address, this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const Color textColor = Colors.white;

    final Size screenSize = MediaQuery.of(context).size;
    const double baseWidth = 375.0;
    final double scaleFactor = screenSize.width / baseWidth;

    final double iconSize = 15.0 * scaleFactor.clamp(0.85, 1.4);
    final double horizontalPadding = 12.0 * scaleFactor.clamp(0.85, 1.0);
    final double verticalPadding = 14.0 * scaleFactor.clamp(0.85, 1.4);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Medium.png'),
            fit: BoxFit.fill,
            filterQuality: FilterQuality.low
          ),
          // borderRadius: BorderRadius.circular(30.0 * scaleFactor),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 5.0 * scaleFactor),

            Flexible(
              child: Text(
                address,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontSize: getResponsiveFontSize(context, 12),
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 6.0 * scaleFactor),
            SvgPicture.asset(
              'assets/icons/walletIcon.svg',
              width: iconSize,
              height: iconSize,
            ),
          ],
        ),
      ),
    );
  }
}
