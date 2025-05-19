import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycoinpoll_metamask/application/module/userDashboard/dashboard.dart';
import 'package:mycoinpoll_metamask/application/presentation/screens/login/validation_screen.dart';

import '../../../../framework/components/BlockButton.dart';
import '../../../../framework/components/ListingFields.dart';
import '../../../module/dashboard_bottom_nav.dart';


class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  TextEditingController userNameOrIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = screenHeight > screenWidth;
    final baseSize = isPortrait ? screenWidth : screenHeight;
    final textScale = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      extendBodyBehindAppBar: true,

      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: BoxDecoration(
            // color: const Color(0xFF0B0A1E),
            color: const Color(0xFF01090B),
            image: DecorationImage(
              // image: AssetImage('assets/icons/gradientBgImage.png'),
              // fit: BoxFit.contain,
              image: AssetImage('assets/icons/starGradientBg.png'),
              fit: BoxFit.cover,
              alignment: Alignment.topRight,
            ),
          ),
          child: Column(
            children: [
              // SizedBox(height: screenHeight * 0.01),

              ///Back Button
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: SvgPicture.asset(
                      'assets/icons/back_button.svg',
                      color: Colors.white,
                      width: screenWidth * 0.04,
                      height: screenWidth * 0.04
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              /// Main Scrollable Content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: screenHeight * 0.01,
                    left: screenWidth * 0.01,
                    right: screenWidth * 0.01,
                    bottom: screenHeight * 0.02,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: screenHeight * 0.02),

                        _headerSection(context),

                        SizedBox(height: screenHeight * 0.02),


                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              /// Email and Password
                               Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/icons/longinContainer.png'),
                                    fit: BoxFit.fill,
                                   ),
                                ),


                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.06,
                                    vertical: screenHeight * 0.03,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,

                                    children: [
                                      /// Email
                                      Text(
                                        'Email or Username',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.normal,
                                          fontSize: baseSize * 0.045,
                                          height: .80,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: screenHeight * 0.01),
                                      /// Email Input Field
                                      ListingField(
                                        controller: userNameOrIdController,
                                        labelText: 'Enter email or username or unique ID',
                                        height: screenHeight * 0.05,
                                        width: screenWidth* 0.88,
                                        expandable: false,
                                        keyboard: TextInputType.name,
                                      ),

                                      SizedBox(height: screenHeight * 0.02),

                                      /// Password
                                      Text(
                                        'Password',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.normal,
                                          fontSize: baseSize * 0.045,
                                          height: 0.80,
                                          color: Colors.white,
                                        ),
                                      ),

                                      SizedBox(height: screenHeight * 0.01),

                                      /// Password Input Field
                                      ListingField(
                                        controller: passwordController,
                                        labelText: 'Enter valid password',
                                        height: screenHeight * 0.05,
                                        width: screenWidth* 0.88,
                                        expandable: false,
                                        keyboard: TextInputType.emailAddress,
                                        isPassword: true,
                                      ),
                                      SizedBox(height: screenHeight * 0.04),

                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [

                                          /// Login Button adn navigate to validation screen
                                          BlockButton(
                                            height: screenHeight * 0.05,
                                            width: screenWidth * 0.88,
                                            label: 'Login Now',
                                            textStyle: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w600,
                                               fontSize: screenWidth * 0.040 * textScale,
                                              height: 0.8,
                                              color: Colors.white,
                                            ),
                                            gradientColors: const [
                                              Color(0xFF2680EF),
                                              Color(0xFF1CD494),
                                            ],
                                            onTap: () {
                                              // Check / Read the user Email and password and navigate
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => ValidationScreen(
                                                  getUserNameOrId: userNameOrIdController.text,
                                                )),
                                              );
                                            },
                                          ),
                                          SizedBox(height: screenHeight * 0.01),

                                          Row(
                                            children: [

                                              Spacer(),
                                              Expanded(
                                                child: Container(
                                                  height: 1.5,
                                                  decoration: const BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                                child: ShaderMask(
                                                  shaderCallback: (bounds) => const LinearGradient(
                                                    colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                                                  ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                                                  child:  Text(
                                                    'OR',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.normal,
                                                      fontFamily: 'Poppins',
                                                      fontSize: baseSize * 0.030,

                                                      color: Colors.white, // Required for ShaderMask to apply
                                                      letterSpacing: 1,
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              // Right Gradient Line
                                              Expanded(
                                                child: Container(
                                                  height: 1.5,
                                                  decoration: const BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [Color(0xFF0072FF), Color(0xFF00C6FF)],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Spacer(),

                                            ],
                                          ),
                                          SizedBox(height: screenHeight * 0.01),


                                          /// Connect Wallet
                                          BlockButton(
                                            height: screenHeight * 0.05,
                                            width: screenWidth * 0.88,
                                            label: 'Connect Wallet',
                                            textStyle: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w600,
                                              fontSize: screenWidth * 0.040 * textScale,
                                              height: 0.8,
                                              color: Colors.white,
                                            ),
                                            gradientColors: const [
                                              Color(0xFF2680EF),
                                              Color(0xFF1CD494),
                                            ],
                                            onTap: () {
                                              // Apply the wallet connection from view model and navigate to the Dashboard
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => DashboardBottomNavBar()),
                                              );
                                            },
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

                        SizedBox(height: screenHeight * 0.02),
                      ],
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


  Widget _headerSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
         children: [

          Image.asset(
            'assets/icons/applyForLisitngImg1.png',
            height: screenHeight * 0.05,
            fit: BoxFit.contain,
          ),

          SizedBox(height: screenHeight * 0.01),
          Text(
            'Sign in to your \nAccount',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFEEEEEE),
              fontSize: screenHeight * 0.036,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              height:1.3,
            ),
          ),
        ],
      ),
    );
  }

}




