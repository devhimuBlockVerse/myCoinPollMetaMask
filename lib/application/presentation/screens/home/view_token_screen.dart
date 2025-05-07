import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../framework/components/BlockButton.dart';
import '../../../../framework/components/WhitePaperButtonComponent.dart';
import '../../../../framework/components/badgeComponent.dart';
import '../../../../framework/components/disconnectButton.dart';
import 'home_screen.dart';


class ViewTokenScreen extends StatefulWidget {
  const ViewTokenScreen({super.key});

  @override
  State<ViewTokenScreen> createState() => _ViewTokenScreenState();
}

class _ViewTokenScreenState extends State<ViewTokenScreen> {

  String selectedBadge = 'AIRDROP';

  void _onBadgeTap(String badge) {
    setState(() {
      selectedBadge = badge;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = screenHeight > screenWidth;
    final baseSize = isPortrait ? screenWidth : screenHeight;
    return Scaffold(
      extendBodyBehindAppBar: true,

      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: BoxDecoration(
            // color: const Color(0xFF0B0A1E),
            color: const Color(0xFF01090B),
            image: DecorationImage(
              image: AssetImage('assets/icons/gradientBgImage.png'),
              fit: BoxFit.contain,
              alignment: Alignment.topRight,
            ),
          ),
          child: Column(
            children: [
              ///Back Button
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/back_button.svg',
                    color: Colors.white,
                    width: 15,
                    height: 15,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              /// Main Scrollable Content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: screenHeight * 0.01,
                    left: screenWidth * 0.01,
                    right: screenWidth * 0.01,
                    bottom: screenHeight * 0.02,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [


                        /// Login Button Section

                        _buildTokenCard(),
                        SizedBox(height: screenHeight * 0.06),


                        /// Listing  Section Form



                        SizedBox(height: screenHeight * 0.02),


                        /// Submit & Clear Button Section

                        SizedBox(height: screenHeight * 0.02),


                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildTokenCard() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = screenHeight > screenWidth;
    final baseSize = isPortrait ? screenWidth : screenHeight;

    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// Token Card
          Container(
            width: screenWidth,
            // constraints: BoxConstraints(maxWidth: screenWidth * 0.95),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  Color(0xff010219),
                  Color(0xff050A7F)],
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
                  color: Color(0x80010227),
                  offset: Offset(0, 0.75),
                  blurRadius: 0,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(baseSize * 0.025),
              child: Column(
                children: [
                  /// Image and Info
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Token image with badges
                      Stack(
                        children: [

                          ClipPath(
                            clipper: DiagonalCornerClipper(),
                            child: Image.asset(
                              'assets/icons/tokens.png',
                              width: screenWidth * 0.4,
                              height: screenHeight * 0.15,
                              fit: BoxFit.fitWidth,
                            ),
                          ),

                          Positioned(
                            top: screenHeight * 0.01,
                            left: screenWidth * 0.03,
                            right: screenWidth * 0.01,
                            child: Row(
                              children: [
                                BadgeComponent(
                                  text: 'AIRDROP',
                                  isSelected: selectedBadge == 'AIRDROP',
                                  onTap: () => _onBadgeTap('AIRDROP'),
                                ),
                                SizedBox(width: screenWidth * 0.01),
                                BadgeComponent(
                                  text: 'INITIAL',
                                  isSelected: selectedBadge == 'INITIAL',
                                  onTap: () => _onBadgeTap('INITIAL'),
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                      SizedBox(width: baseSize * 0.02),

                      /// Token details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'eCommerce Coin (ECM)',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: baseSize * 0.035,
                                color: Color(0xffFFF5ED),
                              ),
                            ),
                            SizedBox(height: baseSize * 0.01),
                            Text(
                              'Join the ECM Token ICO to revolutionize e-commerce with blockchain.',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                fontSize: baseSize * 0.028,
                                color: Color(0xffFFF5ED),
                              ),
                            ),
                            SizedBox(height: baseSize * 0.01),

                            /// Timer Section
                            Padding(
                              padding: EdgeInsets.all(baseSize * 0.01),
                              child: Container(
                                // width: double.infinity,
                                width: screenWidth,
                                padding: EdgeInsets.symmetric(
                                  // horizontal: baseSize * 0.01,
                                  // vertical: baseSize * 0.015,
                                  horizontal: baseSize * 0.02,
                                  vertical: baseSize * 0.015,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0x4D1F1F1F),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    width: 0.3,
                                    color: const Color(0x4DFFFFFF),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _timeBlock(label: 'Days', value: '02'),
                                      _timerColon(baseSize),
                                      _timeBlock(label: 'Hours', value: '23'),
                                      _timerColon(baseSize),
                                      _timeBlock(label: 'Minutes', value: '05'),
                                      _timerColon(baseSize),
                                      _timeBlock(label: 'Seconds', value: '56'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: baseSize * 0.025),

                  /// Supporters and Raised
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Supporter: 726',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: baseSize * 0.025,
                          color: Color(0xffFFF5ED),
                        ),
                      ),
                      SizedBox(height: baseSize * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Raised: 1.12%',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: baseSize * 0.025,
                              color: Color(0xffFFF5ED),
                            ),
                          ),
                          Text(
                            '1118527.50 / 10000000.00',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: baseSize * 0.025,
                              color: Color(0xffFFF5ED),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: baseSize * 0.02),

                  LinearProgressIndicator(
                    value: 0.5,
                    minHeight: 2,
                    backgroundColor: Colors.white24,
                    color: Colors.cyanAccent,
                  ),
                  SizedBox(height: baseSize * 0.04),

                  /// Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 9.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // SizedBox(width: baseSize * 0.02),
                            _imageButton(
                              context,
                              'assets/icons/xIcon.svg',
                                  () {
                                print('Image button tapped!');
                              },
                            ),
                            SizedBox(width: baseSize * 0.02),
                            _imageButton(
                              context,
                              'assets/icons/teleImage.svg',
                                  () {
                                print('Image button tapped!');
                              },
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: baseSize * 0.02),

                      WhitePaperButtonComponent(
                        label: 'White Paper',
                        color: Colors.white,
                        onPressed: () {},
                        width: screenWidth * 0.3,
                        height: screenHeight * 0.04,
                      ) ,
                      // SizedBox(width: baseSize * 0.02),

                      WhitePaperButtonComponent(
                        label: 'Official Website',
                        color: Colors.white,
                        onPressed: () {},
                        width: screenWidth * 0.3,
                        height: screenHeight * 0.04,
                      )

                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// _imageButton Widget
  Widget _imageButton(BuildContext context, String imagePath, VoidCallback onTap) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageSize = screenWidth * 0.04; // 5% of screen width

    final isSvg = imagePath.toLowerCase().endsWith('.svg');

    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.all(8),
        child: isSvg
            ? SvgPicture.asset(
          imagePath,
          width: imageSize,
          height: imageSize,
          color: Colors.white,
        )
            : Image.asset(
          imagePath,
          width: imageSize,
          height: imageSize,
          color: Colors.white,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
  /// Countdown Widget
  Widget _timerColon(double baseSize) {
    return Baseline(
      baseline: baseSize * 0.01,
      baselineType: TextBaseline.alphabetic,
      child: Text(
        ":",
        style: TextStyle(
          fontSize: baseSize * 0.045,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
  Widget _timeBlock({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      // mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 4),

          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            border: Border.all(color: const Color(0xFF2B2D40), width: 0.25),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 18,
              height: 0.2,
              letterSpacing: 0.16,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 1),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            fontSize: 8,
            height: 1.2,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }


}
