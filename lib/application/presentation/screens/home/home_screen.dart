import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mycoinpoll_metamask/framework/components/disconnectButton.dart';

import '../../../../framework/components/BlockButton.dart';
import '../../../../framework/components/buy_ecm_button.dart';
import '../bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(

      extendBodyBehindAppBar: true,
      backgroundColor: Color(0xFF0B0A1E),
      body: Stack(
       children: [
         Positioned(
           top: -screenHeight * 0.01,
           right: -screenWidth * 0.09,
           child: Container(
             width: screenWidth ,
             height: screenWidth ,
             decoration: BoxDecoration(
               shape: BoxShape.circle,
             ),
             child: Image.asset(
               'assets/icons/gradientBgImage.png',
               width: screenWidth ,
               height: screenHeight ,
               fit: BoxFit.fill,
             ),
           ),

         ),

         SafeArea(
           child: Padding(
             padding: EdgeInsets.symmetric(
               horizontal: screenWidth * 0.04,
               vertical: screenHeight * 0.02,
             ),
             child: Column(
               children: [

                 /// Hello + Name + Settings Section
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text(
                           'Hello,',
                           textAlign: TextAlign.start,
                           style: TextStyle(
                             color: Colors.white,
                             fontSize: screenWidth * 0.045,
                             // fontWeight: FontWeight.normal,
                             fontFamily: 'Poppins-Regular'
                           ),
                         ),
                         SizedBox(height: screenHeight * 0.001),
                         Text(
                           'Rashadul Islam Himu',
                           style: TextStyle(
                             color: Colors.white,
                             fontSize: screenWidth * 0.055,
                             fontWeight: FontWeight.bold,
                             fontFamily: 'Poppins-SemiBold',
                             height: 0.8,
                           ),
                           textAlign: TextAlign.start,
                         ),
                       ],
                     ),

                     /// Settings Icon (top right)
                     GestureDetector(
                       onTap: () {
                         // Action
                       },
                       child: Padding(
                         padding: EdgeInsets.only(top: screenHeight * 0.005),
                         child: Image.asset(
                           'assets/icons/settingsIcon.png',
                           width: screenWidth * 0.07,
                           height: screenWidth * 0.07,
                           color: Colors.white,
                         ),
                       ),
                     )
                   ],
                 ),

                 SizedBox(height: screenHeight * 0.04),

                 Container(
                   width: screenWidth,
                   height: screenHeight * 0.16,
                   decoration: BoxDecoration(
                     border: Border.all(
                         color: Colors.transparent
                     ),
                     image:const DecorationImage(
                       image: AssetImage('assets/icons/applyForListingBG.png'),
                       fit: BoxFit.fill,
                     ),
                   ),

                   /// Apply For Lisign Button

                   child: Stack(
                     children: [
                       Container(
                         padding: EdgeInsets.symmetric(
                           horizontal: screenWidth * 0.035,
                           vertical: screenHeight * 0.015,
                         ),
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.start,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text(
                               'Blockchain Innovation \nLaunchpad Hub',
                               style: TextStyle(
                                 color: Color(0xFFFFF5ED),
                                 fontFamily: 'Poppins',
                                 fontSize: screenWidth * 0.04,
                                 fontWeight: FontWeight.w400,
                               ),
                               maxLines: 2,
                             ),
                             // SizedBox(height: screenHeight * 0.01), // Make this smaller the Space)

                             /// Apply For Lising Button
                             Padding(
                               padding:  EdgeInsets.only(left: screenWidth * 0.010, top: screenHeight * 0.020),
                               child: BlockButton(
                                 height: screenHeight * 0.05,
                                 width: screenWidth * 0.4,
                                 label: 'Apply For Listing',
                                 textStyle:  TextStyle(
                                   fontWeight: FontWeight.w700,
                                   color: Colors.white,
                                   fontSize: screenWidth * 0.030,
                                 ),
                                 gradientColors: const [
                                   Color(0xFF2680EF),
                                   Color(0xFF1CD494)
                                   // 1CD494
                                 ],
                                 onTap: () {
                                   print('Button tapped');
                                 },
                                 iconPath: 'assets/icons/arrowIcon.png',
                                 iconSize : screenHeight * 0.028,
                               ),
                             ),
                           ],
                         ),
                       ),
                       Align(
                         alignment: Alignment.centerRight,
                         child: Padding(
                           padding: EdgeInsets.only(left: screenWidth * 0.02),
                           child: Image.asset(
                             'assets/icons/frame.png',
                             width: screenWidth * 0.4,
                             height: screenHeight * 0.4,
                             fit: BoxFit.fitWidth,
                           ),
                         ),
                       ),
                     ]
                   ),
                 )
               ],
             ),
           ),
         ),



       ]
      ),
    );
  }
}
