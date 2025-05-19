import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/dynamicFontSize.dart';


class WalletAddressComponent extends StatelessWidget {
  final String address;

  const WalletAddressComponent({
    Key? key,
    required this.address,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color textColor = Colors.white;

    final Size screenSize = MediaQuery.of(context).size;
    final double baseWidth = 375.0;
    final double scaleFactor = screenSize.width / baseWidth;

    final double iconSize = 15.0 * scaleFactor.clamp(0.85, 1.4);
    final double horizontalPadding = 24.0 * scaleFactor.clamp(0.85, 1.4);
    final double verticalPadding = 12.0 * scaleFactor.clamp(0.85, 1.4);

    return Center(
      child: Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/icons/Medium.png'),
            fit: BoxFit.fitHeight,
          ),
          borderRadius: BorderRadius.circular(30.0 * scaleFactor),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(width: 4.0 * scaleFactor),

            Flexible(
              child: Text(
                address,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontSize: getResponsiveFontSize(context, 10),
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // SizedBox(width: 8.0 * scaleFactor),
            Spacer(),
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
