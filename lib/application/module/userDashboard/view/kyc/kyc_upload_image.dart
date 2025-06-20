import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycoinpoll_metamask/application/module/userDashboard/view/kyc/kyc_screen.dart';
import 'package:provider/provider.dart';
import '../../../../../framework/components/BlockButton.dart';
import '../../../../../framework/utils/dynamicFontSize.dart';
import '../../../../../framework/utils/enums/kyc_track.dart';
import '../../../side_nav_bar.dart';
import '../../viewmodel/kyc_navigation_provider.dart';
import '../../viewmodel/side_navigation_provider.dart';
import 'kyc_upload_selfie.dart';
import 'widget/upload_image.dart';


class KycUploadImage extends StatefulWidget {
  const KycUploadImage({super.key});

  @override
  State<KycUploadImage> createState() => _KycUploadImageState();
}

class _KycUploadImageState extends State<KycUploadImage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isChecked = false;


  @override
  void initState() {
     super.initState();
     Provider.of<KycNavigationProvider>(context, listen: false)
         .setLastVisitedScreen(KycScreenType.kycUploadImage);
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
           decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/icons/affiliateBg.png'),
              fit: BoxFit.cover,
              alignment: Alignment.topRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                      onPressed: () =>Navigator.push(context, MaterialPageRoute(builder: (context) =>  KycScreen()))
                  ),
                  Expanded(
                    child: Text(
                      ' Upload Image of  ID Card',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: getResponsiveFontSize(context, 16),
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.12),
                ],
              ),


              // Main content area
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.03,
                    vertical: screenHeight * 0.01,
                  ),
                  child: ListView(
                    children: [

                      /// Upload Images
                      const UploadCard(title: 'Upload front page',uploadKey: 'front'),
                      SizedBox(height: screenHeight * 0.03),
                      const UploadCard(title: 'Upload back page', uploadKey: 'back',),

                      SizedBox(height: screenHeight * 0.03),


                      _buildInfo('Government-issued', 'assets/icons/checkInfo.svg'),
                       SizedBox(height: screenHeight * 0.01),

                      _buildInfo('Original full-size, unedited document', 'assets/icons/checkInfo.svg'),
                       SizedBox(height: screenHeight * 0.01),

                      _buildInfo('Place documents against a single-coloured background', 'assets/icons/checkInfo.svg'),
                       SizedBox(height: screenHeight * 0.01),

                      _buildInfo('Readable, well-lit, coloured images', 'assets/icons/checkInfo.svg'),
                       SizedBox(height: screenHeight * 0.01),

                      _buildInfo('No black and white images', 'assets/icons/crossInfo.svg'),
                       SizedBox(height: screenHeight * 0.01),

                      _buildInfo('No edited or expired documents', 'assets/icons/crossInfo.svg'),
                       SizedBox(height: screenHeight * 0.03),


                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Transform.scale(
                            scale: 1.5,
                            child: Checkbox(
                              activeColor: Colors.white,
                              checkColor: Colors.black,
                              value: isChecked,
                              onChanged: (val) {
                                setState(() {
                                  isChecked = val!;
                                });
                              },
                            ),
                          ),

                          Expanded(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return RichText(
                                  text: TextSpan(
                                    text: 'This information is used for identity verification only, and will be kept secure by ',
                                    style: TextStyle(
                                      fontSize: getResponsiveFontSize(context, 13),
                                      color: const Color(0xFFA7ADBF),
                                      fontStyle: FontStyle.italic,
                                      fontFamily: 'Poppins',
                                    ),
                                    children: const [
                                      TextSpan(
                                        text: 'mycoinpoll',
                                        style: TextStyle(
                                          color: Color(0xFFA7ADBF),
                                          decoration: TextDecoration.underline,
                                          decorationColor: Colors.white,
                                          decorationThickness: 1.5,
                                          decorationStyle: TextDecorationStyle.solid,
                                        ),
                                      ),
                                    ],
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                );
                              },
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: screenHeight * 0.02),

                      Center(
                        child: Opacity(
                          opacity: isChecked ? 1.0 : 0.5,
                          child: IgnorePointer(
                            ignoring: !isChecked,
                            child: BlockButton(
                              height: screenHeight * 0.05,
                              width: screenWidth * 0.7,
                              label: 'Continue',
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
                                 Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => KycUploadSelfie()), (route) => false);
                              },

                            ),
                          ),
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


  Widget _buildInfo(
      String title,
      String iconPath,
      ){
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(iconPath,fit: BoxFit.contain,height: screenHeight * 0.03,),
         SizedBox(width: screenWidth * 0.02),
         Expanded(
            child: Text(
             title,
             textAlign: TextAlign.start,
             style: TextStyle(
               color: Color(0XFFA7AEBF),
               fontFamily: "Poppins",
               fontSize: getResponsiveFontSize(context, 13),
               fontWeight: FontWeight.w400,
           ),),
         )
      ],
    );
  }


}





