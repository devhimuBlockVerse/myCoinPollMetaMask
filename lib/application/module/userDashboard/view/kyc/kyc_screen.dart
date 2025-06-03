import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../../../framework/components/BlockButton.dart';
import '../../../../../framework/components/customDropDownComponent.dart';
import '../../../../../framework/utils/dynamicFontSize.dart';
import '../../../../../framework/utils/enums/kyc_track.dart';
import '../../../dashboard_bottom_nav.dart';
import '../../../side_nav_bar.dart';
import '../../viewmodel/kyc_navigation_provider.dart';
import '../../viewmodel/side_navigation_provider.dart';
import 'kyc_upload_image.dart';

class KycScreen extends StatefulWidget {
  const KycScreen({super.key});

  @override
  State<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends State<KycScreen> {

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
  void initState() {
    super.initState();
    Provider.of<KycNavigationProvider>(context, listen: false)
        .setLastVisitedScreen(KycScreenType.kycScreen);

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
                                    selectedCardIndex = index;
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
                       if (selectedCardIndex >= 0) _kycVerification(),

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


  Widget _kycVerification(){
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final bool isPortrait = screenHeight > screenWidth;
    final baseSize = isPortrait ? screenWidth : screenHeight;

    final bool isCardSelected = selectedCardIndex >= 0 && selectedCardIndex < _documentTypes.length;

    final ImageProvider displayImageProvider = isCardSelected
        ? AssetImage(_documentTypes[selectedCardIndex]['icon']!)
        : const NetworkImage("https://picsum.photos/24/18");

    final String submissionText = isCardSelected
        ? _documentTypes[selectedCardIndex]['submissionText']!
        : 'Please select a document type above';


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


        SizedBox(height: screenHeight * 0.04),

        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            "Verification requires the following:",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: getResponsiveFontSize(context, 14),
              height: 1.6,
              color: Colors.white,
            ),
          ),
        ),

        SizedBox(height: screenHeight * 0.03),

        /// Select Country of Resident:
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "Select Country of Resident:",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: getResponsiveFontSize(context, 12),
                    height: 1.6,
                    color: Colors.white,
                  ),
                ),
              ),
            ),


            SizedBox(width: screenWidth * 0.08),

            Expanded(
              child: CustomDropdown(
                label: 'Country',
                items: const ['Dubai', 'USA', 'Bangladesh'],
                selectedValue: _selectedCountry,
                onChanged: (value) {
                  setState(() {
                    _selectedCountry = value;
                  });
                  print('Selected country: $_selectedCountry');
                },
              ),
            ),
          ],
        ),

        SizedBox(height: screenHeight * 0.05),

        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            "Selected your valid Government-issued document",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: getResponsiveFontSize(context, 12),
              height: 1.6,
              color: Colors.white,
            ),
          ),
        ),


        SizedBox(height: screenHeight * 0.02),


        /// Show User Selected index from _buildStatCard()
        Container(
          width: screenWidth,
          height: screenHeight * 0.05,
          padding:  EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          decoration: ShapeDecoration(
            color: Color(0xFF172C4B).withOpacity(0.20),
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 0.50, color: Color(0xFF4E4D50)),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 24,
                height: 18,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: displayImageProvider,
                    fit: BoxFit.contain,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.53),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                submissionText,

                style: TextStyle(
                  color: Colors.white,
                  fontSize: getResponsiveFontSize(context, 14),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: screenHeight * 0.03),


        Center(
          child: BlockButton(
            height: screenHeight * 0.05,
            width: screenWidth * 0.7,
            label: 'Start Verification',
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
              // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => KycInProgressScreen()), (route) => false);
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => KycUploadImage()), (route) => false);
            },
            iconPath: 'assets/icons/arrowIcon.svg',
            iconSize : screenHeight * 0.013,
          ),


        ),


      ],
    );

  }


}

