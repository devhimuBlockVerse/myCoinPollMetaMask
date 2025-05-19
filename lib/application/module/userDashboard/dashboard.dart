import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../framework/components/walletAddressComponent.dart';
import '../../../framework/utils/dynamicFontSize.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = screenHeight > screenWidth;

    // Dynamic multipliers
    final baseSize = isPortrait ? screenWidth : screenHeight;
    return Scaffold(

      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: BoxDecoration(
             image: DecorationImage(
               image: AssetImage('assets/icons/starGradientBg.png'),
              fit: BoxFit.cover,
              alignment: Alignment.topRight,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.01,
                vertical: screenHeight * 0.02,
              ),
              child: Column(
                children: [

                  ///MyCoinPoll & Connected Wallet Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Padding(
                        padding: EdgeInsets.only(
                            top: screenHeight * 0.01,
                            right: screenWidth * 0.02
                        ),
                        child: Image.asset(
                          'assets/icons/mycoinpolllogo.png',
                          width: screenWidth * 0.40,
                          height: screenHeight * 0.040,
                          fit: BoxFit.contain,
                        ),
                      ),

                      /// Connected Wallet Button
                      Padding(
                        padding: EdgeInsets.only(
                          top: screenHeight * 0.01,
                          right: screenWidth * 0.02,
                        ), // Padding to Button
                        child: const WalletAddressComponent(
                          address: "0xe2...e094", // Show wallet address string
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.03),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}




