import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mycoinpoll_metamask/application/presentation/screens/bottom_nav_bar.dart';
import 'package:mycoinpoll_metamask/application/presentation/screens/settings/privacy_policy_screen.dart';
import 'package:provider/provider.dart';
 import 'package:shared_preferences/shared_preferences.dart';
import '../../../../framework/components/profileOptionCompoent.dart';
 import '../../../../framework/widgets/custom_contact_info.dart';
import '../../../module/userDashboard/viewmodel/dashboard_nav_provider.dart';
import '../../../module/userDashboard/viewmodel/side_navigation_provider.dart';
import '../../viewmodel/bottom_nav_provider.dart';
import '../../viewmodel/personal_information_viewmodel/personal_view_model.dart';
import '../../viewmodel/wallet_view_model.dart';
import 'feedback_screen.dart';
import 'personal_info/personal_information.dart';
 import 'terms_condition_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isDisconnecting = false;

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
                 image: AssetImage('assets/images/solidBackGround.png'),
                fit: BoxFit.cover,
                alignment: Alignment.topRight,
                  filterQuality: FilterQuality.low

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
                     'Account Settings',
                     style: TextStyle(
                       fontFamily: 'Poppins',
                       color: Colors.white,
                       fontWeight: FontWeight.w600,
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
                                  image: const DecorationImage(
                                    image: AssetImage('assets/images/profileFrameBg.png'),
                                   fit: BoxFit.fill,
                                      filterQuality: FilterQuality.low
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

                                     ProfileOptionContainer(
                                      labelText: 'Personal Information',
                                      leadingIconPath: 'assets/icons/profile.svg',
                                      trailingIconPath: 'assets/icons/rightArrow.svg',
                                      onTrailingIconTap: () {

                                        Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) => const PersonalInformationScreen()),
                                        );
                                      },
                                     ),

                                     SizedBox(height: screenHeight * 0.02),

                                     ProfileOptionContainer(
                                       labelText: 'Privacy Policy',
                                       leadingIconPath: 'assets/icons/privecyImg.svg',
                                       trailingIconPath: 'assets/icons/rightArrow.svg',
                                       onTrailingIconTap: () {
                                         Navigator.push(
                                           context,
                                           MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
                                         );
                                       },
                                     ),
                                     SizedBox(height: screenHeight * 0.02),

                                     ProfileOptionContainer(
                                       labelText: 'Terms and Conditions',
                                       leadingIconPath: 'assets/icons/termsImg.svg',
                                       trailingIconPath: 'assets/icons/rightArrow.svg',
                                       onTrailingIconTap: () {
                                         Navigator.push(
                                           context,
                                           MaterialPageRoute(builder: (context) => const TermsConditionScreen()),
                                         );
                                       },
                                     ),

                                     SizedBox(height: screenHeight * 0.02),

                                     ProfileOptionContainer(
                                       labelText: 'Feedback',
                                       leadingIconPath: 'assets/icons/feedbackImg.svg',
                                       trailingIconPath: 'assets/icons/rightArrow.svg',
                                       onTrailingIconTap: () {
                                         Navigator.push(
                                           context,
                                           MaterialPageRoute(builder: (context) => const FeedbackScreen()),
                                         );
                                       },
                                     ),
                                     SizedBox(height: screenHeight * 0.02),


                                     ProfileOptionContainer(
                                       labelText: 'Logout',
                                       labelTextColor: Colors.redAccent.withOpacity(0.9),
                                       leadingIconPath: 'assets/icons/logoutImg.svg',
                                       trailingIconPath: 'assets/icons/rightArrow.svg',
                                       iconColor: Colors.redAccent.withOpacity(0.9),
                                       onTrailingIconTap: ()async {
                                         setState(() {
                                           isDisconnecting = true;
                                         });
                                         final walletVm = Provider.of<WalletViewModel>(context, listen: false);
                                         try{
                                           await walletVm.disconnectWallet(context);

                                           walletVm.reset();
                                           final prefs = await SharedPreferences.getInstance();
                                           await prefs.clear();

                                           Provider.of<BottomNavProvider>(context, listen: false).setIndex(0);
                                           if(context.mounted && !walletVm.isConnected){
                                             Navigator.of(context).pushAndRemoveUntil(
                                                 MaterialPageRoute(
                                                   builder: (context) => MultiProvider(
                                                     providers: [
                                                       ChangeNotifierProvider(create: (context) => WalletViewModel(),),
                                                       ChangeNotifierProvider(create: (_) => BottomNavProvider()),
                                                       ChangeNotifierProvider(create: (_) => DashboardNavProvider()),
                                                       ChangeNotifierProvider(create: (_) => PersonalViewModel()),
                                                       ChangeNotifierProvider(create: (_) => NavigationProvider()),
                                                     ],
                                                     child: const BottomNavBar(),
                                                   )
                                                 ),(Route<dynamic> route) => false,
                                             );
                                           }

                                         }catch(e){
                                           debugPrint("Error Wallet Disconnecting : $e");
                                         }finally{
                                           if(mounted){
                                             setState(() {
                                               isDisconnecting = false;
                                             });
                                           }
                                         }
                                       },
                                     ),

                                     SizedBox(height: screenHeight * 0.04),
                                     SizedBox(
                                       width: screenWidth * 0.8,
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
                                     SizedBox(height: screenHeight * 0.01),

                                     const CustomContactInfo(
                                       emailAddress: 'support@mycoinpoll.com',
                                     ),
                                     SizedBox(height: screenHeight * 0.01),


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

              Text(

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


            ],
          ),
        ),
      ],
    );
  }

}






