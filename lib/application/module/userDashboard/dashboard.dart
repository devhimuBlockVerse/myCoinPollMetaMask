import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycoinpoll_metamask/application/presentation/viewmodel/wallet_view_model.dart';
import 'package:provider/provider.dart';

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
                  SizedBox(height: screenHeight * 0.03),


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




}




