import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mycoinpoll_metamask/application/presentation/screens/profile/settings/settings_screen.dart';
import 'package:mycoinpoll_metamask/application/presentation/screens/profile/tax_statement/terms_condition_screen.dart';
import 'package:mycoinpoll_metamask/application/presentation/screens/profile/trade_confirmation/trade_confirmation_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../framework/components/profileOptionCompoent.dart';
import '../../models/user_model.dart';
import '../../viewmodel/bottom_nav_provider.dart';
import '../../viewmodel/personal_information_viewmodel/personal_view_model.dart';
import 'notification/notifications.dart';
import 'personal_info/personal_information.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    _loadFullNameFromPrefs();
  }

  Future<void> _loadFullNameFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('firstName') ?? '';
    Provider.of<BottomNavProvider>(context, listen: false).setFullName(name);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,

      body: SafeArea(
          top: false,

          child: Container(
            width: screenWidth,
            height: screenHeight,
            decoration: const BoxDecoration(
              color: Color(0xFF01090B),
              image: DecorationImage(
                // image: AssetImage('assets/icons/starGradientBg.png'),
                image: AssetImage('assets/icons/solidBackGround.png'),
                fit: BoxFit.cover,
                alignment: Alignment.topRight,

              ),
            ),


            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
               crossAxisAlignment: CrossAxisAlignment.center,
               children: [
                 SizedBox(height: screenHeight * 0.02),
                 Align(
                   alignment: Alignment.topCenter,
                   child:  Text(
                     'Profile',
                     style: TextStyle(
                       fontFamily: 'Poppins',
                       color: Colors.white,
                       fontWeight: FontWeight.w600,
                       // fontSize: 20
                       fontSize: screenWidth * 0.05,
                     ),
                     textAlign: TextAlign.center,
                   ),
                 ),

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
                           crossAxisAlignment: CrossAxisAlignment.center,
                           children: [
                             SizedBox(height: screenHeight * 0.02),

                             _profileHeaderSection(),

                             SizedBox(height: screenHeight * 0.03),

                             /// Profile Action Buttons =>
                             Container(
                               width: double.infinity,

                               decoration: BoxDecoration(
                                 // color: const Color(0xFF01090B),
                                 image: const DecorationImage(
                                    image: AssetImage('assets/icons/profileFrameBg.png'),
                                   fit: BoxFit.fill,
                                  ),
                                 borderRadius: BorderRadius.circular(14),
                                 border: Border.all(
                                   color: const Color(0XFFFFF5ED),
                                   width: 0.1,
                                 ),
                               ),

                               child: Padding(
                                 padding: EdgeInsets.symmetric(
                                   horizontal: screenWidth * 0.05,
                                   vertical: screenHeight * 0.02,
                                 ),
                                 child: Column(
                                   mainAxisSize: MainAxisSize.min,
                                   children: [

                                     // Personal ,
                                     ProfileOptionContainer(
                                      labelText: 'Personal Information',
                                      leadingIconPath: 'assets/icons/profile.svg',
                                      trailingIconPath: 'assets/icons/rightArrow.svg',
                                      onTrailingIconTap: () {
                                        debugPrint("Trailing icon tapped");
                                        Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) => const PersonalInformationScreen()),
                                        );
                                      },
                                     ),
                                     SizedBox(height: screenHeight * 0.02),

                                     // Trade Confirmation,
                                     ProfileOptionContainer(
                                      labelText: 'Trade Confirmation',
                                      leadingIconPath: 'assets/icons/tared.svg',
                                      trailingIconPath: 'assets/icons/rightArrow.svg',
                                      onTrailingIconTap: () {
                                        debugPrint("Trailing icon tapped");
                                        Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) => const TradeConfirmationScreen()),
                                        );
                                      },
                                     ),
                                     SizedBox(height: screenHeight * 0.02),

                                     // Tax Statements,
                                     ProfileOptionContainer(
                                      labelText: 'Tax Statements',
                                      leadingIconPath: 'assets/icons/taxStatement.svg',
                                      trailingIconPath: 'assets/icons/rightArrow.svg',
                                      onTrailingIconTap: () {
                                        debugPrint("Trailing icon tapped");
                                        Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) => const TermsConditionScreen()),
                                        );
                                      },
                                     ),
                                     SizedBox(height: screenHeight * 0.02),

                                     // Notification Settings,
                                     ProfileOptionContainer(
                                       labelText: 'Notification Settings',
                                       leadingIconPath: 'assets/icons/notify.svg',
                                       trailingIconPath: 'assets/icons/rightArrow.svg',
                                       onTrailingIconTap: () {
                                         debugPrint("Trailing icon tapped");
                                         Navigator.of(context).push(
                                         MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                                       );
                                       },
                                     ),
                                     SizedBox(height: screenHeight * 0.02),

                                     // Settings
                                     ProfileOptionContainer(
                                       labelText: 'Settings',
                                       leadingIconPath: 'assets/icons/settings.svg',
                                       trailingIconPath: 'assets/icons/rightArrow.svg',
                                       onTrailingIconTap: () {
                                         debugPrint("Trailing icon tapped");
                                         Navigator.of(context).push(
                                           MaterialPageRoute(builder: (context) => const SettingsScreen()),
                                         );
                                       },
                                     ),

                                     SizedBox(height: screenHeight * 0.02),

                                     SizedBox(
                                       width: screenWidth * 0.8, // Responsive width
                                       child: Opacity(
                                         opacity: 0.50,
                                         child: Text(
                                           'This service is provided by Team.',
                                           textAlign: TextAlign.center,
                                           style: TextStyle(
                                             color: Colors.white,
                                             fontSize: screenWidth * 0.028,
                                             fontFamily: 'Poppins',
                                             fontWeight: FontWeight.w400,
                                             height: 1.6,
                                           ),
                                         ),
                                       ),
                                     ),
                                     SizedBox(height: screenHeight * 0.04),


                                   ],
                                 ),
                               ),
                             ),

                           ],
                         ),
                       ),
                     ),
                   ),
                 ),
              ],
            ),
          )

      ),
    );
  }



  Widget _profileHeaderSection(){
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final fullName = Provider.of<BottomNavProvider>(context).fullName;
    final profileVM = Provider.of<PersonalViewModel>(context);
    final pickedImage = profileVM.pickedImage;


    // Scale factors (tweak if needed)
    double scale = screenWidth / 375;
    return Column(
      children: [
        Container(
          width: screenWidth * 0.5,
          padding: EdgeInsets.symmetric(vertical: 10 * scale),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Show User Profile Image
              Container(
                width: screenWidth * 0.26,
                height: screenWidth * 0.26,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                   image: pickedImage != null
                      ? FileImage(pickedImage)
                      : (profileVM.originalImagePath != null && File(profileVM.originalImagePath!).existsSync())
                      ? FileImage(File(profileVM.originalImagePath!))
                      : const NetworkImage("https://mycoinpoll.com/_ipx/q_20&s_50x50/images/dashboard/icon/user.png") as ImageProvider,

                  fit: BoxFit.fill,
                  ),
                  shape: OvalBorder(
                    side: BorderSide(width: 1 * scale, color: Colors.white),
                  ),
                ),
              ),

              SizedBox(height: 10 * scale),

              // Name
              Text(
                 // fullName,
                fullName.isNotEmpty ? fullName : 'Ethereum User',

                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20 * scale,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),

              SizedBox(height: 10 * scale),

              // Membership Badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10 * scale,
                  vertical: 6 * scale,
                ),
                decoration: ShapeDecoration(
                  color: const Color(0xFFF7F9B7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5 * scale),
                  ),
                ),
                child: Text(
                  'Premium Member',
                  style: TextStyle(
                    color: const Color(0xFF18181D),
                    fontSize: 12 * scale,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    height: 1.3,

                  ),
                ),
              ),

              SizedBox(height: 5 * scale),

              // Upgrade Plan Button
              GestureDetector(
                onTap: () {
                  /// Handle upgrade tap
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10 * scale,
                    vertical: 4 * scale,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Upgrade your plan',
                        style: TextStyle(
                          color: const Color(0xFFF7F9B7),
                          fontSize: 10 * scale,
                          fontFamily: 'Poppins',
                          letterSpacing: -0.3,
                          fontWeight: FontWeight.w400,
                          height: 1.3,
                        ),
                      ),
                      SizedBox(width: 6 * scale),
                      Icon(
                        Icons.arrow_forward,
                        size: 12 * scale,
                        color: const Color(0xFFF7F9B7),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

}






