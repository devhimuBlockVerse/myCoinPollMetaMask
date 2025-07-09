import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycoinpoll_metamask/application/presentation/screens/bottom_nav_bar.dart';
import 'package:mycoinpoll_metamask/application/presentation/screens/profile/trade_confirmation/trade_confirmation_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../framework/components/customSettingsActionButtonComponent.dart';
import '../../../../module/userDashboard/viewmodel/dashboard_nav_provider.dart';
import '../../../../module/userDashboard/viewmodel/kyc_navigation_provider.dart';
import '../../../../module/userDashboard/viewmodel/side_navigation_provider.dart';
import '../../../../module/userDashboard/viewmodel/upload_image_provider.dart';
import '../../../viewmodel/bottom_nav_provider.dart';
import '../../../viewmodel/personal_information_viewmodel/personal_view_model.dart';
import '../../../viewmodel/wallet_view_model.dart';
import '../tax_statement/terms_condition_screen.dart';
import 'contact_screen.dart';
import 'feedback_screen.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {


  bool isDisconnecting = false;

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final isPortrait = screenHeight > screenWidth;
    final baseSize = isPortrait ? screenWidth : screenHeight;


    return  Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor:  Colors.transparent,
      body: SafeArea(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: const BoxDecoration(
            color: Color(0xFF01090B),
            image: DecorationImage(

              image: AssetImage('assets/icons/solidBackGround.png'),
              fit: BoxFit.cover,
              alignment: Alignment.topRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              SizedBox(height: screenHeight * 0.01),

              Row(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: SvgPicture.asset(
                        'assets/icons/back_button.svg',
                        color: Colors.white,
                        width: screenWidth * 0.04,
                        height: screenWidth * 0.04
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Settings',
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
                  SizedBox(width: screenWidth * 0.12), // Responsive spacer for balance
                ],
              ),

              SizedBox(height: screenHeight * 0.01),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.01,
                  ),
                  child: ScrollConfiguration(
                    behavior: const ScrollBehavior().copyWith(overscroll: false),
                    child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: screenHeight * 0.05),

                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),

                              child: Column(
                                children: [

                                  CustomSettingsActionButton(
                                    icon: 'assets/icons/languageImg.svg',
                                    text: 'Language',
                                    onPressed: (){},
                                  ),

                                  SizedBox(height: screenHeight * 0.01),

                                  CustomSettingsActionButton(
                                    icon: 'assets/icons/rateImg.svg',
                                    text: 'Rate App',
                                    onPressed: (){},
                                  ),
                                  SizedBox(height: screenHeight * 0.01),

                                  CustomSettingsActionButton(
                                    icon: 'assets/icons/shareImg.svg',
                                    text: 'Share App',
                                    onPressed: (){},
                                  ),
                                  SizedBox(height: screenHeight * 0.01),

                                  CustomSettingsActionButton(
                                    icon: 'assets/icons/privecyImg.svg',
                                    text: 'Privacy Policy',
                                    onPressed: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const TradeConfirmationScreen()),
                                      );
                                    },
                                  ),
                                  SizedBox(height: screenHeight * 0.01),

                                  CustomSettingsActionButton(
                                    icon: 'assets/icons/termsImg.svg',
                                    text: 'Terms and Conditions',
                                    onPressed: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const TermsConditionScreen()),
                                      );
                                    },
                                  ),
                                  SizedBox(height: screenHeight * 0.01),

                                  CustomSettingsActionButton(
                                    icon: 'assets/icons/contactImg.svg',
                                    text: 'Contact',
                                    onPressed: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const ContactScreen()),
                                      );
                                    },
                                  ),
                                  SizedBox(height: screenHeight * 0.01),

                                  CustomSettingsActionButton(
                                    icon: 'assets/icons/feedbackImg.svg',
                                    text: 'Feedback',
                                    onPressed: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const FeedbackScreen()),
                                      );
                                    },
                                  ),
                                  SizedBox(height: screenHeight * 0.01),

                                  CustomSettingsActionButton(
                                    icon: 'assets/icons/logoutImg.svg',
                                    text: 'Logout',
                                    onPressed: ()async{
                                      setState(() {
                                        isDisconnecting = true;
                                      });

                                      final walletVM = Provider.of<WalletViewModel>(context, listen: false);

                                      try{
                                        final prefs = await SharedPreferences.getInstance();
                                        await prefs.clear();

                                        await walletVM.disconnectWallet(context);
                                        // walletVM.reset();

                                        if (context.mounted && !walletVM.isConnected) {
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(builder: (context) => const BottomNavBar()),
                                          // );
                                          Navigator.of(context).pushAndRemoveUntil(
                                            MaterialPageRoute(
                                              builder: (context) => MultiProvider(
                                                providers: [
                                                  ChangeNotifierProvider(create: (context) => WalletViewModel(),),
                                                  ChangeNotifierProvider(create: (_) => BottomNavProvider()),
                                                  ChangeNotifierProvider(create: (_) => DashboardNavProvider()),
                                                  ChangeNotifierProvider(create: (_) => PersonalViewModel()),
                                                  ChangeNotifierProvider(create: (_) => NavigationProvider()),
                                                  ChangeNotifierProvider(create: (_) => KycNavigationProvider()),
                                                  ChangeNotifierProvider(create: (_) => UploadProvider()),
                                                ],
                                                child: const BottomNavBar(),
                                              ),
                                            ),
                                                (Route<dynamic> route) => false,
                                          );
                                        }
                                      }catch(e){
                                        debugPrint("Error Wallet Disconnecting : $e");
                                      }finally{
                                        if (mounted) {
                                          setState(() {
                                            isDisconnecting = false;
                                          });
                                        }
                                      }
                                      // DisConnect The User Session and Navigate Back to Home Screen .
                                    },
                                  ),


                                ],
                              ),
                            ),


                          ],
                        )
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

}

