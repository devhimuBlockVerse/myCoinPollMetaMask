import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycoinpoll_metamask/application/module/userDashboard/view/kyc/kyc_screen.dart';
import 'package:provider/provider.dart';
import '../../../../../framework/components/BlockButton.dart';
import '../../../../../framework/utils/dynamicFontSize.dart';
import '../../../../../framework/utils/enums/kyc_track.dart';
import '../../../../../framework/utils/status_styling_utils.dart';
import '../../../dashboard_bottom_nav.dart';
import '../../../side_nav_bar.dart';
import '../../viewmodel/kyc_navigation_provider.dart';
import '../../viewmodel/side_navigation_provider.dart';


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
      'icon': 'assets/images/nid.png',
      'submissionText': 'NID Submission Required',
    },
    {
      'title': 'Passport',
      'icon': 'assets/images/passport.png',
      'submissionText': 'Passport Submission Required',
    },
    {
      'title': 'Driving License',
      'icon': 'assets/images/drivingLicense.png',
      'submissionText': 'Driving License Submission Required',
    },
  ];


  @override
  void initState() {
    super.initState();
    Provider.of<KycNavigationProvider>(context, listen: false)
        .setLastVisitedScreen(KycScreenType.kycStatus);

  }

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
              image: AssetImage('assets/images/starGradientBg.png'),
              fit: BoxFit.cover,
              alignment: Alignment.topRight,
                filterQuality: FilterQuality.low
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
                      onPressed: () =>Navigator.push(context, MaterialPageRoute(builder: (context) =>  DashboardBottomNavBar()))
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
                  child: ScrollConfiguration(
                    behavior: const ScrollBehavior().copyWith(overscroll: false),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),

                      child: Column(
                        children: [


                          Container(
                            width: screenWidth,
                            decoration:const BoxDecoration(
                              image:  DecorationImage(
                                image: AssetImage('assets/images/selectDocumentBg.png'),
                                fit: BoxFit.fill,
                                  filterQuality: FilterQuality.low
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
                                image: AssetImage('assets/images/estimatedBG.png'),
                                fit: BoxFit.fill,
                                  filterQuality: FilterQuality.low
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
    String _userKycStatus = 'Rejected';
    StatusStyling statusStyle = getKycUserStatusStyle(_userKycStatus);


    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Container(
          width: screenWidth,
          decoration:const BoxDecoration(
            image:  DecorationImage(
              image: AssetImage('assets/images/selectDocumentBg.png'),
              fit: BoxFit.fill,
                filterQuality: FilterQuality.low
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

              LayoutBuilder(
                builder: (context, constraints) {
                  final screenWidth = constraints.maxWidth;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /// Left side - Reference Number
                      Expanded(
                        flex: 1,
                        child: Text(
                          "Reference Number: #12542463",
                           style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: getResponsiveFontSize(context, 12),
                            color: Colors.white70,
                          ),
                        ),
                      ),

                      // SizedBox(width: 10),

                      /// Right side - Status label + Container
                      Flexible(
                        flex: 1,

                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Status: ",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: getResponsiveFontSize(context, 12),
                                color: Colors.white,
                              ),
                            ),
                             SizedBox(width: screenWidth * 0.01),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.03,
                                vertical: screenWidth * 0.01,
                              ),
                              decoration: BoxDecoration(
                                color: statusStyle.backgroundColor,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: statusStyle.borderColor, width: 0.5),
                              ),
                              child: Text(
                                _userKycStatus,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  fontSize: getResponsiveFontSize(context, 11),
                                  color: statusStyle.textColor,
                                  height: 1.1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),

              SizedBox(height: screenHeight * 0.02),

              if (_userKycStatus == "Pending")
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Once your request is processed, you'll receive a notification ensure prompt communication to keep you updated on the status and provide timely updates.",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: getResponsiveFontSize(context, 12),
                        height: 1.6,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),

                    Container(
                      width: screenWidth,
                      decoration:const BoxDecoration(
                        image:  DecorationImage(
                          image: AssetImage('assets/images/estimatedBG.png'),
                          fit: BoxFit.fill,
                            filterQuality: FilterQuality.low
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
                                "Estimated Processing Time: 24-48 Hours.",
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
                  ],
                ),


              if (_userKycStatus == 'Approved')
                Text(
                "Your submission has been successfully approved. You will receive a confirmation notification shortly. We appreciate your cooperation and will keep you informed of any further updates.",
                style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: getResponsiveFontSize(context, 12),
                height: 1.6,
                color: Colors.white,

                ),
                )
              else if (_userKycStatus == 'Rejected')
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                    "We couldn't verify your details due to inconsistencies in the provided documents. Kindly resubmit with accurate and clear information.",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: getResponsiveFontSize(context, 12),
                      height: 1.6,
                      color: Colors.white,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    Container(
                      width: screenWidth,
                      decoration:const BoxDecoration(
                        image:  DecorationImage(
                          image: AssetImage('assets/images/rejectedStatusBg.png'),
                          fit: BoxFit.fill,
                            filterQuality: FilterQuality.low
                        ),
                      ),
                      child: Flexible(
                        flex: 5,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            " Please review your information and try again!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w400,
                              fontSize: getResponsiveFontSize(context, 12),
                              height: 1.6,
                              color: Color(0xFFE2AD36),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.04),

                    BlockButton(
                      height: screenHeight * 0.05,
                      width: screenWidth * 0.7,
                      label: 'Start Verification Again',
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
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => KycScreen()), (route) => false);
                      },
                      iconPath: 'assets/icons/arrowIcon.svg',
                      iconSize : screenHeight * 0.013,
                    ),

                  ],
                ),




            ]
          ),
        )
        



      ],
    );

  }

}
