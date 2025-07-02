
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../framework/components/BlockButton.dart';
import '../../../../framework/components/ListingFields.dart';
import '../../../../framework/components/buy_Ecm.dart';
import '../../../../framework/utils/general_utls.dart';
import '../../../data/services/api_service.dart';
import '../../../module/dashboard_bottom_nav.dart';
import '../../viewmodel/wallet_view_model.dart';
import 'forgot_password.dart';


class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  TextEditingController userNameOrIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
     WidgetsBinding.instance.addPostFrameCallback((_) async {
      final walletVM = Provider.of<WalletViewModel>(context, listen: false);

      final prefs = await SharedPreferences.getInstance();
      final wasConnected = prefs.getBool('isConnected') ?? false;
      print("WalletViewModel.isConnected: ${walletVM.isConnected}, SharedPref: $wasConnected");


      if (!walletVM.isConnected && wasConnected && walletVM.appKitModal==null) {
        debugPrint("Attempting silent reconnect...");
        await walletVM.init(context);
      }

    });
  }

   Future<void> login() async {
    final username = userNameOrIdController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await ApiService().login(username, password);
      print('Logged in as: ${response.user.name}, Token: ${response.token}');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardBottomNavBar()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => isLoading = false);
    }
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
          decoration: const BoxDecoration(
            // color: const Color(0xFF0B0A1E),
            color: Color(0xFF01090B),
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
                                decoration: const BoxDecoration(
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
                                      SizedBox(height: screenHeight * 0.02),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => const ForgotPassword()),
                                            );
                                          },
                                          child: Text(
                                            'Forgot Password?',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.normal,
                                              fontSize: baseSize * 0.032,
                                              height: 0.80,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: screenHeight * 0.04),



                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [

                                          /// Login Button adn navigate to validation screen
                                          isLoading
                                              ? const Center(child: CircularProgressIndicator())
                                              :BlockButton(
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
                                            // onTap: () {
                                            //    Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(builder: (context) => ValidationScreen(
                                            //       getUserNameOrId: userNameOrIdController.text,
                                            //     )),
                                            //   );
                                            // },
                                            onTap: login,
                                          ),
                                          SizedBox(height: screenHeight * 0.01),

                                          Row(
                                            children: [

                                              const Spacer(),
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
                                              const Spacer(),

                                            ],
                                          ),
                                          SizedBox(height: screenHeight * 0.01),




                                          /// Connect Wallet
                                          Consumer<WalletViewModel>(
                                            builder: (context, walletVM, _) {
                                              if (walletVM.isLoading || _isNavigating) {
                                                return const Center(child: CircularProgressIndicator());
                                              }
                                              return BlockButtonV2(
                                                text: walletVM.isConnected ? 'Go To Dashboard':'Connect Wallet',

                                                onPressed:  walletVM.isLoading ? null : () async {
                                                  setState(() => _isNavigating = true);

                                                  try {
                                                    if (!walletVM.isConnected) {
                                                      await walletVM.connectWallet(context);
                                                    }
                                                     if (walletVM.isConnected && context.mounted) {
                                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => const DashboardBottomNavBar(),
                                                        ),
                                                      );
                                                    }
                                                  } catch (e, stack) {
                                                    debugPrint('Wallet Error: $e\n$stack');
                                                    if (context.mounted) {
                                                      Utils.flushBarErrorMessage("Error: ${e.toString()}", context);
                                                    }
                                                  }finally{
                                                    if (mounted) setState(() => _isNavigating = false);

                                                  }
                                                },

                                                height: screenHeight * 0.05,
                                                width: screenWidth * 0.88,
                                              );
                                            }

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

                        // const ToastMessage(
                        //   type: MessageType.info,
                        //   title: 'Charger is under maintenance',
                        //   subtitle: 'Please select another charger.',
                        // ),
                        //
                        // const ToastMessage(
                        //   type: MessageType.success,
                        //   title: 'Payment successful!',
                        //   subtitle: 'Your transaction has been completed.',
                        // ),
                        //
                        // const ToastMessage(
                        //   type: MessageType.error,
                        //   title: 'Connection Lost',
                        //   subtitle: 'Please check your internet connection.',
                        // ),

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

    return SizedBox(
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
              color: const Color(0xFFEEEEEE),
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








// class Frame1413377636 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final double screenWidth = MediaQuery.of(context).size.width;
//     final double cardWidth = screenWidth * 0.9 > 400 ? 400 : screenWidth * 0.9;
//     final double baseTitleFontSize = 14.0;
//     final double baseSubtitleFontSize = 12.0;
//
//     final double titleFontSize = baseTitleFontSize * (screenWidth / 375);
//     final double subtitleFontSize = baseSubtitleFontSize * (screenWidth / 375);
//
//     return Center(
//       child: Column(
//         children: [
//           Container(
//             width: cardWidth,
//             padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
//             decoration: ShapeDecoration(
//               gradient: const LinearGradient(
//                 begin: Alignment.topRight,
//                 end: Alignment.bottomLeft,
//                  colors: [Color(0xFF2C1F2C), Color(0xFF101A29)],
//               ),
//               shape: RoundedRectangleBorder(
//                 side: BorderSide(width: 1, color: Color(0xFF2B2D40)),
//                 borderRadius: BorderRadius.circular(5),
//               ),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                  Container(
//                   height: 40,
//                   width: 40,
//                   padding: const EdgeInsets.all(4),
//                   decoration: ShapeDecoration(
//                     color: Color(0xFF303746),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(43),
//                     ),
//                   ),
//                   child: Center(
//                     child: Icon(
//                       Icons.build_circle_outlined,
//                       color: Colors.white,
//                       size: 24,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//
//                 // Vertical Divider
//                 VerticalDivider(
//                   width: 2,
//                   thickness: 1,
//                   color: Colors.white.withOpacity(0.5),
//                   indent: 5,
//                   endIndent: 5,
//                 ),
//                 const SizedBox(width: 10),
//
//                  Expanded(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Charger is under maintenance',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: titleFontSize,
//                           fontFamily: 'Poppins',
//                         ),
//                       ),
//                       const SizedBox(height: 5),
//                       Text(
//                         'Please select another charger.',
//                         style: TextStyle(
//                           color: Color(0xFFC7C5C5),
//                           fontSize: subtitleFontSize,
//                           fontFamily: 'Poppins',
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

