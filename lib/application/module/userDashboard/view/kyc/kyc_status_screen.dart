import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../../../framework/components/BlockButton.dart';
import '../../../../../framework/components/customDropDownComponent.dart';
import '../../../../../framework/utils/dynamicFontSize.dart';
import '../../../../../framework/utils/status_styling_utils.dart';
import '../../../side_nav_bar.dart';
import '../../viewmodel/side_navigation_provider.dart';
import '../dashboard/dashboard_screen.dart';


class KycStatusScreen extends StatefulWidget {
  const KycStatusScreen({super.key});

  @override
  State<KycStatusScreen> createState() => _KycStatusScreenState();
}

class _KycStatusScreenState extends State<KycStatusScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int selectedCardIndex = -1;
  String? _selectedCountry;

  final List<Map<String, String>> _documentTypes = [
    {
      'title': 'National Id Card',
      'icon': 'assets/icons/nid.png',
      'submissionText': 'NID Submission Required',
    },
    {
      'title': 'Passport',
      'icon': 'assets/icons/passport.png',
      'submissionText': 'Passport Submission Required',
    },
    {
      'title': 'Driving License',
      'icon': 'assets/icons/drivingLicense.png',
      'submissionText': 'Driving License Submission Required',
    },
  ];

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
                      onPressed: () =>Navigator.push(context, MaterialPageRoute(builder: (context) =>  DashboardScreen()))
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "KYC Verification",
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



                      /// Stat Cards

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: List.generate(_documentTypes.length, (index) {
                          final docType = _documentTypes[index];
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: index < _documentTypes.length - 1 ? itemSpacing : 0,
                              ),
                              child: _buildStatCard(
                                title: docType['title']!,
                                emojiIcon: docType['icon']!,
                                selected: selectedCardIndex == index,
                                onTap: () {
                                  setState(() {
                                    // selectedCardIndex = index;
                                  });
                                  print("Tapped card $index, new index: $index");
                                },
                              ),
                            ),
                          );
                        }),
                      ),

                      SizedBox(height: screenHeight * 0.03),

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

                      SizedBox(height: screenHeight * 0.06),


                      /// _kycVerification
                      _kycVerificationStatus(),

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
    VoidCallback? onTap,
    required bool selected,


  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final borderRadius = screenWidth * 0.009;
    final verticalContentPadding = screenWidth * 0.03;

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
              SizedBox(height: 3),

              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: getResponsiveFontSize(context, 12),
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w400,
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


  Widget _kycVerificationStatus(){
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final bool isPortrait = screenHeight > screenWidth;
    final baseSize = isPortrait ? screenWidth : screenHeight;


    // This will come from your model/API
    String _userKycStatus = 'Pending';
    StatusStyling statusStyle = getKycUserStatusStyle(_userKycStatus);


    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

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
                  'assets/icons/kycVerify.svg',
                  width: screenWidth * 0.04,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: screenWidth * 0.02),
              Flexible(
                flex: 3,
                child: Text(
                  "KYC Verification Status",
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


        SizedBox(height: screenHeight * 0.04),


        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                     _userKycStatus == "Rejected"
                        ? 'assets/icons/statusRejected.svg'
                        : 'assets/icons/statusCehck.svg',
                     width: getResponsiveFontSize(context, 18),
                    height: getResponsiveFontSize(context, 18),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Text(
                    _userKycStatus == 'Approved' ? "Submission Approved!" :
                        _userKycStatus == "Rejected" ? "Your KYC verification was rejected" :
                        "Submission Received!",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: getResponsiveFontSize(context, 14),
                      height: 1.6,
                      color: Colors.white,
                    ),
                  )
                ],
              ),

              SizedBox(height: screenHeight * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Reference Number: #12542463",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: getResponsiveFontSize(context, 12),
                      color: Colors.white70,
                    ),
                  ),


                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.03,
                      vertical: screenWidth * 0.01,
                    ),
                    decoration: BoxDecoration(
                      color: statusStyle.backgroundColor,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: statusStyle.borderColor,width: 0.5),
                    ),
                    child: Text(
                      _userKycStatus,
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: getResponsiveFontSize(context, 11),
                          color: statusStyle.textColor,
                          height: 1.1
                      ),
                    ),
                  )

                ],
              ),

              SizedBox(height: screenHeight * 0.02),

              if (_userKycStatus == "Pending")
                Text(
                  "Once your request is processed, you'll receive a notification ensure prompt communication to keep you updated on the status and provide timely updates.",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: getResponsiveFontSize(context, 12),
                    height: 1.6,
                    color: Colors.white70,
                  ),
                ),

              if (_userKycStatus == 'Approved')
                Text(
                "Your submission has been successfully approved. You will receive a confirmation notification shortly. We appreciate your cooperation and will keep you informed of any further updates.",
                style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: getResponsiveFontSize(context, 12),
                height: 1.6,
                color: Colors.white70,

                ),
                )
              else if (_userKycStatus == 'Rejected')
                Text(
                "We couldn't verify your details due to inconsistencies in the provided documents. Kindly resubmit with accurate and clear information.",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: getResponsiveFontSize(context, 12),
                  height: 1.6,
                  color: Colors.white70,
                  ),
                ),

            ]
          ),
        )
        



      ],
    );

  }

}
