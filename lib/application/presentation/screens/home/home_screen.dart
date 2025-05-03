import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mycoinpoll_metamask/framework/components/disconnectButton.dart';
import 'package:provider/provider.dart';

import '../../../../framework/components/BlockButton.dart';
import '../../../../framework/components/buy_ecm_button.dart';
import '../../viewmodel/bottom_nav_provider.dart';
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
    final isPortrait = screenHeight > screenWidth;

    // Dynamic multipliers
    final baseSize = isPortrait ? screenWidth : screenHeight;
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
             child: SingleChildScrollView(
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
                         child: BlockButton(
                           height: screenHeight * 0.040,
                           width: screenWidth * 0.4,
                           label: 'Connect Wallet',
                           textStyle:  TextStyle(
                             fontWeight: FontWeight.w700,
                             color: Colors.white,
                             fontSize: baseSize * 0.030,
                           ),
                           gradientColors: const [
                             Color(0xFF2680EF),
                             Color(0xFF1CD494)
                             // 1CD494
                           ],
                           onTap: () {
                             Provider.of<BottomNavProvider>(context, listen: false).setIndex(0);  // Go to Home Screen
                           },
               
                         ),
                       ),
                     ],
                   ),
               
                   SizedBox(height: screenHeight * 0.03),
               
                   /// Apply For Lisign Button
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
                   ),



                   SizedBox(height: screenHeight * 0.03),

                   _buildTokenCard(context),

               

                 ],
               ),
             ),
           ),
         ),


       ]
      ),
    );
  }
}

Widget _buildTokenCard(BuildContext context){
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      /// Header Row
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Running Tokens',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 16,
              height: 0.8,
              letterSpacing: 0,
              color: Colors.white,
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'View All',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                height: 0.8,
                letterSpacing: 0,
                color: Colors.white,
              ),
            ),
          ),

        ],
      ),
      const SizedBox(height: 16),

      /// Token Card
      Container(
        decoration: BoxDecoration(
          // color: const Color(0xFF0E1B30),
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors:[
              Color(0xff010219),
              Color(0xff050A7F),
            ],

            begin: Alignment(-1.0, 0.0),
            end: Alignment(1.0, 1.0),
            stops: [0.68, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x80FFFFFF),
              offset: Offset(0, 1),
              blurRadius: 1,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Color(0x80010227) ,
              offset: Offset(0, 0.75),
              blurRadius: 0,
              spreadRadius: 0,
            ),
          ],

        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              /// Top section with image and info
             Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Token image with badges
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/icons/tokens.png',
                          width: 150,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),

                      Positioned(
                        top: 4,
                        left: 4,
                        right: 4, // Allows spacing for both sides
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _badge('AIRDROP', isSelected: true, onTap: () {
                              // Handle AIRDROP badge tap
                            }),
                            const SizedBox(width: 4),
                            _badge('INITIAL', isSelected: false, onTap: () {
                              // Handle INITIAL badge tap
                            }),
                          ],
                        ),
                      ),

                    ],
                  ),


                  const SizedBox(width: 4),

                  /// Token details
                   Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:   [
                        Text(
                          'eCommerce Coin (ECM)',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500, // Medium
                            fontSize: 14,
                            height: 1.0, // 100% line height
                            color: Colors.white,
                          ),
                        ),

                        SizedBox(height: 4),
                        Text(
                          'Join the ECM Token ICO to revolutionize e-commerce with blockchain.',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: 10,
                            height: 1.1,
                            color: Colors.grey,
                          ),
                        ),
                        /// Countdown timer
                        Stack(
                          children: [
                            Container(
                              width: 150,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(0x4D1F1F1F), // #1F1F1F with 30% opacity
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  width: 0.3,
                                  color: const Color(0x4DFFFFFF), // #FFFFFF with 30% opacity
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(9),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _timeBlock(label: 'Days', value: '02'),
                                    SizedBox(width: 4),

                                    _timeBlock(label: 'Hours', value: '23'),
                                    SizedBox(width: 4),
                                    _timeBlock(label: 'Minutes', value: '05'),
                                    SizedBox(width: 4),
                                    _timeBlock(label: 'Seconds', value: '56'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),


              const SizedBox(height: 12),

              /// Supporters and raised
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text('Supporter: 726',
                        style: TextStyle(color: Colors.white70)),
                    Text('Raised: 1.12%',
                        style: TextStyle(color: Colors.white70)),

                  ],
                ),
              ),
               const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '1118527.50 / 10000000.00',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ),

              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: 0.5,
                minHeight: 2,
                backgroundColor: Colors.white24,
                color: Colors.cyanAccent,
              ),

              const SizedBox(height: 16),

              /// Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      _iconButton(Icons.close),
                      const SizedBox(width: 8),
                      _iconButton(Icons.send),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00B5D8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('View Token'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

/// Badge Widget
// Widget _badge(String text, {bool isSelected = false, VoidCallback? onTap}) {
//   return InkWell(
//     onTap: onTap,
//     borderRadius: BorderRadius.circular(4),
//     child: Container(
//
//       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//       decoration: BoxDecoration(
//         color: isSelected ? Colors.blueAccent : Colors.white.withOpacity(0.4),
//         borderRadius: BorderRadius.circular(4),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           fontSize: 10,
//           color:  Colors.white  ,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     ),
//   );
// }
Widget _badge(String text, {required bool isSelected, required VoidCallback onTap}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(4),
    child: Container(
      width: 50,
      height: 25,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? Colors.blueAccent : Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500, // Medium
          fontSize: 7,
          height: 0.8, // Line height = 80%
          color: Colors.white,
        ),
      ),
    ),
  );
}


/// IconButton Widget
Widget _iconButton(IconData icon) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white12,
      borderRadius: BorderRadius.circular(6),
    ),
    padding: const EdgeInsets.all(8),
    child: Icon(icon, size: 16, color: Colors.white),
  );
}

/// Countdown Widget
class _timeBlock extends StatelessWidget {
  final String label;
  final String value;

  const _timeBlock({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Row(
            children: [
              Text(
                "${value}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  height: 0.8,
                  letterSpacing: 0.16 ,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 4,),
        Center(
          child: Text(label,
            textAlign: TextAlign.center, // Align center horizontally
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400, // Regular
              fontSize: 8,
              height: 0.8, // 80% line height
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
