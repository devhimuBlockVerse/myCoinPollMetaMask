import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../../../framework/components/buildProgressBar.dart';
import '../../../../../framework/components/featureCard.dart';
import '../../../../../framework/components/statusIndicatorComponent.dart';
import '../../../../../framework/utils/dynamicFontSize.dart';
import '../../../../data/user_activity_dummy_data.dart';
import '../../../side_nav_bar.dart';
import '../../viewmodel/side_navigation_provider.dart';
import '../milestone/widget/user_activity_table.dart';

class AffiliateScreen extends StatefulWidget {
  const AffiliateScreen({super.key});

  @override
  State<AffiliateScreen> createState() => _AffiliateScreenState();
}

class _AffiliateScreenState extends State<AffiliateScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> _filteredData = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _filteredData = List.from(activityData);

  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final bool isPortrait = screenHeight > screenWidth;
    final baseSize = isPortrait ? screenWidth : screenHeight;

    final textScale = screenWidth / 375;

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
            children: [
              // App bar row
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
                  // Text(
                  //   'Your Affiliate Progress',
                  //   style: TextStyle(
                  //     fontFamily: 'Poppins',
                  //     color: Colors.white,
                  //     fontWeight: FontWeight.w600,
                  //     fontSize: screenWidth * 0.05,
                  //   ),
                  //   textAlign: TextAlign.center,
                  // ),
                  SizedBox(width: screenWidth * 0.12),
                ],
              ),

              // Main content area
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.01,
                    vertical: screenHeight * 0.01,
                  ),
                  child: ListView(
                    children: [

                      /// Activity Status
                      Text(
                        'Your Affiliate Progress',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: getResponsiveFontSize(context, 16),
                        ),
                        textAlign: TextAlign.start,
                      ),

                      SizedBox(height: screenHeight * 0.02),

                      _affiliateProgress(),

                      SizedBox(height: screenHeight * 0.03),

                      const FeatureCard(
                        iconPath: 'assets/icons/becomeAffiliate.png',
                        title: 'Why Become an Affiliate?',
                        isSvg: false,
                        bulletPoints: [
                          'Earn commissions on every referral sale',
                          'Unlock exclusive bonuses & perks',
                          'Gain priority access to special events',
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),

                     const FeatureCard(
                        iconPath: 'assets/icons/quality.png',
                        isSvg: false,
                        title: 'How to Qualify?',
                        bulletPoints: [
                           'Hold 300 ECM in your wallet',
                          'Refer 2500 ECM in total sales',
                        ],
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02,horizontal: screenWidth * 0.04),
                        decoration:const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/icons/userActivityLogBg2.png'),
                              fit: BoxFit.fill,
                              filterQuality: FilterQuality.high
                          ),
                        ),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [


                            Text(
                              'User Activity Log',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: getResponsiveFontSize(context, 16),
                                height: 1.6,
                                color: Colors.white,
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.02),
                            ...[
                              _filteredData.isNotEmpty
                                  ? buildUserActivity(_filteredData, screenWidth, context)
                                  : Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(20),
                                child: const Text(
                                  'No data found',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ),
                            ],

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


  Widget _affiliateProgress(){
    final Size screenSize = MediaQuery.of(context).size;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final textScale = screenWidth / 375;
    final bool isPortrait = screenSize.height > screenSize.width;

     return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.003,
              horizontal: screenWidth * 0.03,
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/icons/linearFrame.png'),
                fit: BoxFit.fill,
              ),

            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [

                          SizedBox(height: screenHeight * 0.015),
                          Container(
                            width: screenWidth,
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                image: AssetImage('assets/icons/linearFrame2.png'),
                                fit: BoxFit.fill,
                              ),
                              borderRadius: BorderRadius.circular(screenWidth * 0.02),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.05,
                                vertical: screenHeight * 0.02,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ProgressBarUserDashboard(
                                    title: "ECM Holding",
                                    percent: 0.9,
                                    percentText: "280/300",
                                    barColor: const Color(0xFF1CD494),
                                    // textScale: textScale ,
                                    // textScale: getResponsiveFontSize(context, 12),
                                    screenHeight: screenHeight,
                                    screenWidth: screenWidth,
                                  ),
                                  SizedBox(height: screenHeight * 0.012),
                                  ProgressBarUserDashboard(
                                    title: "Referral Sales (ECM)",
                                    percent: 0.4,
                                    percentText: "1200/2500",
                                    barColor: const Color(0xFFF0B90B),
                                    // textScale: textScale,
                                    screenHeight: screenHeight,
                                    screenWidth: screenWidth,
                                  ),
                                  SizedBox(height: screenHeight * 0.016),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [

                                      /// Refactor This Component Later with status Active or Inactive Variation.
                                      Flexible(
                                        child: StatusIndicator(
                                          statusText: 'Not Yet an Affiliator',       /// Variation ->  Already an Affiliate
                                          statusColor: Color(0xFFE04043),            /// Variation -> Color(0xff1CD494)
                                          iconPath: 'assets/icons/crossIcon.svg',   ///Variation ->  checkIconAffiliate.svg
                                        ),
                                      ),



                                    ],
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
                SizedBox(height: screenHeight * 0.01),

              ],
            ),
          ),

        ],
      ),
    );
  }

}
