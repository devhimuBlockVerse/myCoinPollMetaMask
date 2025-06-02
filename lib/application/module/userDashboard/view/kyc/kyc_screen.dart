import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
 import 'package:provider/provider.dart';

import '../../../../../framework/utils/dynamicFontSize.dart';
import '../../../side_nav_bar.dart';
import '../../viewmodel/side_navigation_provider.dart';

class KycScreen extends StatefulWidget {
  const KycScreen({super.key});

  @override
  State<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends State<KycScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int selectedCardIndex = -1;


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final itemSpacing = screenWidth * 0.02;


    final navProvider = Provider.of<NavigationProvider>(context);
    final currentScreenId = navProvider.currentScreenId;
    final navItems = navProvider.drawerNavItems;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      key: _scaffoldKey,
      drawerEnableOpenDragGesture: true,
      drawerEdgeDragWidth: 80,
      drawer: SideNavBar(
        currentScreenId: currentScreenId,
        navItems: navItems,
        onScreenSelected: (id) => navProvider.setScreen(id),
        onLogoutTapped: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Logout Pressed")),
          );
        },
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          // height: screenHeight,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/icons/starGradientBg.png'),
              fit: BoxFit.cover,
              alignment: Alignment.topRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// App bar row
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: SvgPicture.asset(
                      'assets/icons/back_button.svg',
                      color: Colors.white,
                      width: screenWidth * 0.04,
                      height: screenWidth * 0.04,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "KYC Verification Process",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: screenWidth * 0.05,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.12),
                ],
              ),

              /// Main content area
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.02,
                  ),
                  child: ListView(
                    children: [


                      Container(
                        width: screenWidth,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage('assets/icons/selectDocumentBg.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "Select Your Documents:",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: getResponsiveFontSize(context, 12),
                              height: 1.6,
                              color: Colors.white,)
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.02,),



                      // Stat Cards
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              title: 'National Id Card',
                               emojiIcon: "assets/icons/nid.png",
                              selected: selectedCardIndex == 0,
                              onTap: () {
                                print("Tapped card 0, new index: 0");

                                setState(() {
                                  selectedCardIndex = 0;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: itemSpacing),
                          Expanded(
                            child: _buildStatCard(
                              title: 'Passport',

                              emojiIcon: "assets/icons/passport.png",
                              selected: selectedCardIndex == 1,
                              onTap: () {
                                setState(() {
                                  selectedCardIndex = 1;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: itemSpacing),
                          Expanded(
                            child: _buildStatCard(
                              title: 'Driving License',

                              emojiIcon: "assets/icons/drivingLicense.png",
                              selected: selectedCardIndex == 2,
                              onTap: () {
                                setState(() {
                                  selectedCardIndex = 2;
                                });
                              },
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: screenHeight * 0.02,),

                      Container(
                        width: screenWidth,
                        decoration:const BoxDecoration(
                          image:  DecorationImage(
                            image: AssetImage('assets/icons/estimatedBG.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 1,
                              child: SvgPicture.asset(
                                'assets/icons/timerImg.svg',
                                width: screenWidth * 0.04,
                                fit: BoxFit.fill,
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            Flexible(
                              flex: 5,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  "Estimated Completion Time: 5-10 minutes",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w400,
                                    fontSize: getResponsiveFontSize(context, 12),
                                    height: 1.6,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.030),


                      Container(
                        width: screenWidth,
                        decoration:const BoxDecoration(
                          image:  DecorationImage(
                            image: AssetImage('assets/icons/selectDocumentBg.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 1,
                              child: SvgPicture.asset(
                                'assets/icons/kycUser.svg',
                                width: screenWidth * 0.04,
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            Flexible(
                              flex: 3,
                              child: Text(
                                "KYC Verification",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                   fontWeight: FontWeight.w500,
                                  fontSize: getResponsiveFontSize(context, 14),
                                  height: 1.6,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),



                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildStatCard({
    required String title,
    String? emojiIcon,
    required VoidCallback onTap,
    required bool selected,


  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final borderRadius = screenWidth * 0.009;
    final verticalContentPadding = screenWidth * 0.02;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: screenWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
           gradient: selected ? LinearGradient(colors: [
             Color(0xFF1CD494).withOpacity(0.20),
             Color(0xFF1CD494).withOpacity(0.20),]
           ) : const LinearGradient(
            begin: Alignment(0.99, 0.14),
            end: Alignment(-0.99, -0.14),
             colors: [Color(0xFF040C16), Color(0XFF172C4B)],
          ),
          border: Border.all(
             color: selected ? const Color(0xFF1CD494) : const Color(0xFF2B2D40),

            width: 1,
          ),

        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.02,
            vertical: verticalContentPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            // mainAxisSize: MainAxisSize.min,
            children: [
              if (emojiIcon != null)
                SizedBox(
                  width: screenWidth * 0.06,
                  height: screenWidth * 0.06,
                  child: Image.asset(
                    emojiIcon,
                    fit: BoxFit.contain,
                  ),
                ),
              SizedBox(height: 2),

              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: getResponsiveFontSize(context, 12),
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }




}





