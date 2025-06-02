import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycoinpoll_metamask/application/module/userDashboard/view/dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';

import '../../../../../framework/components/BlockButton.dart';
import '../../../../../framework/utils/dynamicFontSize.dart';
import '../../../side_nav_bar.dart';
import '../../viewmodel/side_navigation_provider.dart';
import 'kyc_status_screen.dart';

class KycInProgressScreen extends StatefulWidget {
  const KycInProgressScreen({super.key});

  @override
  State<KycInProgressScreen> createState() => _KycInProgressScreenState();
}

class _KycInProgressScreenState extends State<KycInProgressScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;


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
              IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/back_button.svg',
                  color: Colors.white,
                  width: screenWidth * 0.04,
                  height: screenWidth * 0.04,
                ),
                onPressed: () =>Navigator.push(context, MaterialPageRoute(builder: (context) =>  DashboardScreen()))

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

                      SizedBox(height: screenHeight * 0.1),

                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: screenWidth * 0.5,
                            height: screenWidth * 0.5,
                            child: Image.asset("assets/icons/CTA.png",filterQuality: FilterQuality.high,fit: BoxFit.contain,),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Verification in Progress',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  // fontSize: screenWidth * 0.07,
                                  fontSize: getResponsiveFontSize(context, 24),
                                  fontFamily: 'Poppins',
                                  height: 1.3,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              SizedBox(
                                width: screenWidth * 0.85,
                                child: Text(
                                  'Your documents are being reviewed. This usually takes a few minutes. Stay tuned!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(0xFF787A8D),
                                    // fontSize: screenWidth * 0.035,
                                    fontSize: getResponsiveFontSize(context, 14),

                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                  ),
                                ),
                              ),

                              SizedBox(height: screenHeight * 0.04),

                              BlockButton(
                                height: screenHeight * 0.05,
                                width: screenWidth * 0.7,
                                label: 'Complete',
                                textStyle:  TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  // fontSize: baseSize * 0.040,
                                  fontSize: getResponsiveFontSize(context, 15),
                                  height: 1.6,
                                ),
                                gradientColors: const [
                                  Color(0xFF2680EF),
                                  Color(0xFF1CD494)
                                  // 1CD494
                                ],
                                onTap: () {
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => KycStatusScreen()), (route) => false);
                                },

                              ),

                            ],
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
      ),
    );
  }
}



