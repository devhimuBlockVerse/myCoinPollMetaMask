import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:mycoinpoll_metamask/application/presentation/viewmodel/wallet_view_model.dart';
import 'package:provider/provider.dart';

import '../../../framework/components/AddressFieldComponent.dart';
import '../../../framework/components/BlockButton.dart';
import '../../../framework/components/userBadgeLevelCompoenet.dart';
import '../../../framework/components/walletAddressComponent.dart';
import '../../../framework/utils/dynamicFontSize.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {



  @override
  void initState() {
    super.initState();
    _setGreeting();


  }




  String greeting = "";

  void _setGreeting() {
    final hour = DateTime.now().hour;
    greeting = hour >= 5 && hour < 12
        ? "Good Morning"
        : hour >= 12 && hour < 17
        ? "Good Afternoon"
        : hour >= 17 && hour < 21
        ? "Good Evening"
        : "Good Night";
  }



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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [


                  /// User Name Data & Wallet Address
                  _headerSection(),
                  SizedBox(height: screenHeight * 0.02),



                  _EcmWithGraphChart(),
                  SizedBox(height: screenHeight * 0.03),

                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xff040C16),
                    borderRadius: BorderRadius.circular(12)
                    ),

                    child: ClipRRect(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: CustomLabeledInputField(
                        labelText: 'Referral Link:',
                        hintText: ' https://mycoinpoll.com?ref=125482458661',
                         isReadOnly: true,
                        trailingIconAsset: 'assets/icons/copyImg.svg',
                        onTrailingIconTap: () {
                          debugPrint('Trailing icon tapped');
                        },
                      ),
                    ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }



  Widget _headerSection(){
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = screenHeight > screenWidth;
    // Dynamic multipliers
    final baseSize = isPortrait ? screenWidth : screenHeight;

    return Consumer<WalletViewModel>(
    builder: (context, model, _){
     return   Container(
       width: double.infinity,
       decoration: BoxDecoration(
         color: Colors.transparent.withOpacity(0.1),
       ),
       child: ClipRRect(
         child: BackdropFilter(
           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
           child: Padding(
             padding: EdgeInsets.symmetric(
               horizontal: screenWidth * 0.03,
               vertical: screenHeight * 0.015,
             ),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 /// User Info & Ro Text + Notification
                 Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text(
                       "$greeting",
                       style: TextStyle(
                         fontFamily: 'Poppins',
                         fontWeight: FontWeight.w400,
                         fontSize: getResponsiveFontSize(context, 14),
                         height: 1.6,
                         color: Color(0xffFFF5ED),
                       ),
                     ),
                     Text(
                       'Ro', // your Ro text
                       style: TextStyle(
                         fontFamily: 'Poppins',
                         fontWeight: FontWeight.w600,
                         fontSize: getResponsiveFontSize(context, 18),
                         height: 1.3,
                         color: Color(0xffFFF5ED),
                       ),
                     ),
                     SizedBox(width: 8),

                   ],
                 ),

                 /// Wallet Address
                 Column(
                   mainAxisAlignment: MainAxisAlignment.end,
                   crossAxisAlignment: CrossAxisAlignment.end,
                   children: [
                     Transform.translate(
                       offset: Offset(screenWidth * 0.025, 0),
                       child:  WalletAddressComponent(
                         // address: formatAddress(model.walletAddress),
                         address: "0xe2...e094",
                       ),
                     ),

                     GestureDetector(
                       onTap: (){},
                       child: SvgPicture.asset(
                         'assets/icons/nofitication.svg',
                         height: getResponsiveFontSize(context, 24),
                       ),
                     ),
                   ],
                 ),
               ],
             ),
           ),
         ),
       ),
     );
    });

  }

  Widget _EcmWithGraphChart(){
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
        width: screenWidth,
        height: screenHeight * 0.16,
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.transparent
          ),
          image: const DecorationImage(
            image: AssetImage('assets/icons/applyForListingBG.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          children: [

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.035,
                vertical: screenHeight * 0.015,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/ecm.png',
                              height: screenWidth * 0.04,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(width: screenWidth * 0.01),
                            Text(
                              'ECM Coin',
                              textAlign:TextAlign.start,
                              style: TextStyle(
                                color: Color(0xffFFF5ED),
                                fontFamily: 'Poppins',
                                fontSize: getResponsiveFontSize(context, 16),
                                fontWeight: FontWeight.normal,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                          Text(
                            '20000000', /// Get the Real Value  from Wallet
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontSize: getResponsiveFontSize(context, 24),
                                fontWeight: FontWeight.w600,
                                height: 1.3
                          ),

                        ),
                        SizedBox(height: screenHeight * 0.01),

                        /// Badge Icons (assuming this is related to the left text)
                        Padding(
                          padding:  EdgeInsets.only(left: screenWidth * 0.00), // Adjusted padding
                          child:Text('Show Badge Icons',style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.025),), // Added font size
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [

                        // Badge
                        UserBadgeLevel(
                          label: 'Level-1',
                          iconPath: 'assets/icons/check.svg',
                        ),

                         Image.asset(
                          'assets/icons/staticChart.png',
                          width: screenWidth * 0.48 ,
                          height: screenHeight * 0.08,
                          fit: BoxFit.contain,
                        ),

                         RichText(
                          text:  TextSpan(
                            text: 'Today up to ',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.normal,
                                color: Colors.grey, fontSize: getResponsiveFontSize(context, 10)),
                            children: <TextSpan>[
                              TextSpan(
                                text: '+5.34%', // This text will be dynamically updated by the RealtimeChart widget
                                style: TextStyle(color: Color(0xFF29FFA5),  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.normal,
                                  fontSize: getResponsiveFontSize(context, 10),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
                ],
        )
    );
  }

}