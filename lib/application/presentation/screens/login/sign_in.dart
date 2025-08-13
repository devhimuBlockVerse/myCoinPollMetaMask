import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:reown_appkit/appkit_modal.dart';
import 'package:reown_walletkit/reown_walletkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/crypto.dart';
import '../../../../framework/components/BlockButton.dart';
import '../../../../framework/components/ListingFields.dart';
import '../../../../framework/components/buy_Ecm.dart';
import '../../../../framework/utils/customToastMessage.dart';
import '../../../../framework/utils/enums/toast_type.dart';
 import '../../../data/services/api_service.dart';
import '../../../module/dashboard_bottom_nav.dart';
import '../../viewmodel/user_auth_provider.dart';
import '../../viewmodel/wallet_view_model.dart';
import 'forgot_password.dart';

class SignIn extends StatefulWidget {
  final bool showBackButton;

  const SignIn({super.key, this.showBackButton = true});

  @override
  State<SignIn> createState() => _SignInState();
}

// class _SignInState extends State<SignIn> {
//
//   TextEditingController userNameOrIdController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   bool isLoading = false;
//   bool _isNavigating = false;
//
//   String _generateSignatureMessage(String address) {
//     return [
//       "Welcome to MyCoinPoll!",
//       "",
//       "Signing confirms wallet ownership and agreement to our terms. No transaction or fees involved—authentication only.",
//       "",
//       "Wallet: $address",
//       "",
//       "Thank you for being a part of our community!"
//     ].join("\n");
//   }
//
//   @override
//   void initState() {
//     super.initState();
//      WidgetsBinding.instance.addPostFrameCallback((_) async {
//       final walletVM = Provider.of<WalletViewModel>(context, listen: false);
//
//       final prefs = await SharedPreferences.getInstance();
//       final wasConnected = prefs.getBool('isConnected') ?? false;
//       print("WalletViewModel.isConnected: ${walletVM.isConnected}, SharedPref: $wasConnected");
//
//     });
//   }
//
//    Future<void> login() async {
//     final username = userNameOrIdController.text.trim();
//     final password = passwordController.text.trim();
//
//     if (username.isEmpty || password.isEmpty) {
//
//       ToastMessage.show(
//         message: "Please fill in all fields",
//         subtitle: "Username or Password is empty",
//         type: MessageType.info,
//         duration: CustomToastLength.LONG,
//         gravity: CustomToastGravity.BOTTOM,
//       );
//       return;
//     }
//
//     setState(() => isLoading = true);
//
//     try {
//       final response = await ApiService().login(username, password);
//       print('Logged in as: ${response.user.name}, Token: ${response.token}');
//
//       /// Save token + user data to SharedPreferences
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('token', response.token);
//       await prefs.setString('user', jsonEncode(response.user.toJson()));
//
//       /// Update user provider manually
//       final userAuth = Provider.of<UserAuthProvider>(context, listen: false);
//       await userAuth.loadUserFromPrefs();
//
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const DashboardBottomNavBar()),
//       );
//     } catch (e) {
//       ToastMessage.show(
//         message: "Login Failed",
//         subtitle: "Invalid credentials or server error. Please try again.",
//         type: MessageType.error,
//         duration: CustomToastLength.LONG,
//         gravity: CustomToastGravity.BOTTOM,
//       );
//       print("Login error: $e");
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }
//
//   /// Handles the entire Web3 login flow.
//   Future<void> _handleWeb3Login() async {
//     if (_isNavigating) return;
//     setState(() => _isNavigating = true);
//
//     final walletVM = Provider.of<WalletViewModel>(context, listen: false);
//
//     try {
//       //Ensure wallet is connected
//       if (!walletVM.isConnected) {
//         await walletVM.connectWallet(context);
//       }
//
//       // If connection fails or is cancelled, exit the flow
//       if (!walletVM.isConnected || walletVM.appKitModal?.session == null) {
//         ToastMessage.show(message: "Connection cancelled", subtitle: "Wallet connection is required to proceed.", type: MessageType.info);
//         return;
//       }
//
//       //Generate message and request signature
//       final message = _generateSignatureMessage(walletVM.walletAddress);
//
//       // The message must be hex-encoded for the personal_sign method
//       final hexMessage = bytesToHex(utf8.encode(message), include0x: true);
//
//       final signature = await walletVM.appKitModal!.request(
//         topic: walletVM.appKitModal!.session!.topic,
//         chainId: walletVM.appKitModal!.selectedChain!.chainId,
//         request: SessionRequestParams(
//           method: 'personal_sign',
//           params: [hexMessage, walletVM.walletAddress],
//         ),
//       );
//
//       //Verify signature with your backend
//       final response = await ApiService().web3Login(context,message, walletVM.walletAddress, signature);
//       print('Web3 Login Success: ${response.user.name}, Token: ${response.token}');
//
//       //Save session and navigate
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('token', response.token);
//       await prefs.setString('user', jsonEncode(response.user.toJson()));
//
//       final userAuth = Provider.of<UserAuthProvider>(context, listen: false);
//       await userAuth.loadUserFromPrefs();
//
//       ToastMessage.show(message: "Login Successful", type: MessageType.success);
//
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (_) => const DashboardBottomNavBar()),
//             (_) => false,
//       );
//
//     } catch (e) {
//       final errorString = e.toString().toLowerCase();
//       String subtitle;
//
//       if (errorString.contains("user rejected") || errorString.contains("user cancelled")) {
//         subtitle = "You cancelled the signature request in your wallet.";
//       } else {
//         subtitle = "An unexpected error occurred. Please try again.";
//         print("Web3 Login Error: $e");
//       }
//
//       ToastMessage.show(
//         message: "Login Failed",
//         subtitle: subtitle,
//         type: MessageType.error,
//         duration: CustomToastLength.LONG,
//       );
//     } finally {
//       if (mounted) setState(() => _isNavigating = false);
//     }
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//     final isPortrait = screenHeight > screenWidth;
//     final baseSize = isPortrait ? screenWidth : screenHeight;
//     final textScale = MediaQuery.of(context).textScaleFactor;
//
//     return Scaffold(
//       // extendBodyBehindAppBar: true,
//       // backgroundColor: Colors.transparent,
//       body: SafeArea(
//         child: Container(
//           width: screenWidth,
//           height: screenHeight,
//           decoration: const BoxDecoration(
//             color: Color(0xFF01090B),
//             image: DecorationImage(
//               image: AssetImage('assets/images/starGradientBg.png'),
//               fit: BoxFit.cover,
//               alignment: Alignment.topRight,
//             ),
//           ),
//           child: Column(
//             children: [
//               // SizedBox(height: screenHeight * 0.01),
//
//               ///Back Button
//               widget.showBackButton ? Align(
//                 alignment: Alignment.topLeft,
//                 child: IconButton(
//                   icon: SvgPicture.asset(
//                       'assets/icons/back_button.svg',
//                       color: Colors.white,
//                       width: screenWidth * 0.04,
//                       height: screenWidth * 0.04
//                   ),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//               ) : const SizedBox.shrink(),
//               /// Main Scrollable Content
//               Expanded(
//                 child: Padding(
//                   padding: EdgeInsets.only(
//                     top: screenHeight * 0.01,
//                     left: screenWidth * 0.01,
//                     right: screenWidth * 0.01,
//                     bottom: screenHeight * 0.02,
//                   ),
//                   child: SingleChildScrollView(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(height: screenHeight * 0.02),
//
//                         _headerSection(context),
//
//                         SizedBox(height: screenHeight * 0.02),
//
//
//                         Padding(
//                           padding: const EdgeInsets.all(18.0),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//
//                               /// Email and Password
//                                Container(
//                                 width: double.infinity,
//                                 decoration: const BoxDecoration(
//                                   image: DecorationImage(
//                                     image: AssetImage('assets/images/longinContainer.png'),
//                                     fit: BoxFit.fill,
//                                    ),
//                                 ),
//
//                                 child: Padding(
//                                   padding: EdgeInsets.symmetric(
//                                     horizontal: screenWidth * 0.06,
//                                     vertical: screenHeight * 0.03,
//                                   ),
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//
//                                     children: [
//                                       /// Email
//                                       Text(
//                                         'Email or Username',
//                                         textAlign: TextAlign.start,
//                                         style: TextStyle(
//                                           fontFamily: 'Poppins',
//                                           fontWeight: FontWeight.normal,
//                                           fontSize: baseSize * 0.045,
//                                           height: .80,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                       SizedBox(height: screenHeight * 0.01),
//                                       /// Email Input Field
//                                       ListingField(
//                                         controller: userNameOrIdController,
//                                         labelText: 'Enter email or username or unique ID',
//                                         height: screenHeight * 0.05,
//                                         width: screenWidth* 0.88,
//                                         expandable: false,
//                                         keyboard: TextInputType.name,
//                                       ),
//
//                                       SizedBox(height: screenHeight * 0.02),
//
//                                       /// Password
//                                       Text(
//                                         'Password',
//                                         textAlign: TextAlign.start,
//                                         style: TextStyle(
//                                           fontFamily: 'Poppins',
//                                           fontWeight: FontWeight.normal,
//                                           fontSize: baseSize * 0.045,
//                                           height: 0.80,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//
//                                       SizedBox(height: screenHeight * 0.01),
//
//                                       /// Password Input Field
//                                       ListingField(
//                                         controller: passwordController,
//                                         labelText: 'Enter valid password',
//                                         height: screenHeight * 0.05,
//                                         width: screenWidth* 0.88,
//                                         expandable: false,
//                                         keyboard: TextInputType.emailAddress,
//                                         isPassword: true,
//                                       ),
//                                       SizedBox(height: screenHeight * 0.02),
//                                       Align(
//                                         alignment: Alignment.centerRight,
//                                         child: GestureDetector(
//                                           onTap: () {
//                                             Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                   builder: (context) => const ForgotPassword()),
//                                             );
//                                           },
//                                           child: Text(
//                                             'Forgot Password?',
//                                             style: TextStyle(
//                                               fontFamily: 'Poppins',
//                                               fontWeight: FontWeight.normal,
//                                               fontSize: baseSize * 0.032,
//                                               height: 0.80,
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(height: screenHeight * 0.04),
//
//
//
//                                       Column(
//                                         crossAxisAlignment: CrossAxisAlignment.center,
//                                         children: [
//
//                                           /// Login Button adn navigate to validation screen
//                                           isLoading
//                                               ? const Center(child: CircularProgressIndicator())
//                                               :BlockButton(
//                                             height: screenHeight * 0.05,
//                                             width: screenWidth * 0.88,
//                                             label: 'Login Now',
//                                             textStyle: TextStyle(
//                                               fontFamily: 'Poppins',
//                                               fontWeight: FontWeight.w600,
//                                                fontSize: screenWidth * 0.040 * textScale,
//                                               height: 0.8,
//                                               color: Colors.white,
//                                             ),
//                                             gradientColors: const [
//                                               Color(0xFF2680EF),
//                                               Color(0xFF1CD494),
//                                             ],
//
//                                             onTap: login,
//                                           ),
//                                           SizedBox(height: screenHeight * 0.01),
//
//                                           Row(
//                                             children: [
//
//                                               const Spacer(),
//                                               Expanded(
//                                                 child: Container(
//                                                   height: 1.5,
//                                                   decoration: const BoxDecoration(
//                                                     gradient: LinearGradient(
//                                                       colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//
//                                               Padding(
//                                                 padding: const EdgeInsets.symmetric(horizontal: 12),
//                                                 child: ShaderMask(
//                                                   shaderCallback: (bounds) => const LinearGradient(
//                                                     colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
//                                                   ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
//                                                   child:  Text(
//                                                     'OR',
//                                                     style: TextStyle(
//                                                       fontWeight: FontWeight.normal,
//                                                       fontFamily: 'Poppins',
//                                                       fontSize: baseSize * 0.030,
//
//                                                       color: Colors.white, // Required for ShaderMask to apply
//                                                       letterSpacing: 1,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//
//                                               // Right Gradient Line
//                                               Expanded(
//                                                 child: Container(
//                                                   height: 1.5,
//                                                   decoration: const BoxDecoration(
//                                                     gradient: LinearGradient(
//                                                       colors: [Color(0xFF0072FF), Color(0xFF00C6FF)],
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               const Spacer(),
//
//                                             ],
//                                           ),
//                                           SizedBox(height: screenHeight * 0.01),
//
//
//
//
//                                           /// Connect Wallet
//                                           Consumer<WalletViewModel>(
//                                             builder: (context, walletVM, _) {
//                                               if (walletVM.isLoading || _isNavigating) {
//                                                 return const Center(child: CircularProgressIndicator());
//                                               }
//
//                                               final isConnected = walletVM.isConnected;
//
//                                               return BlockButtonV2(
//                                                 text: isConnected ? 'Go To Dashboard' : 'Connect Wallet',
//                                                 height: screenHeight * 0.05,
//                                                 width: screenWidth * 0.88,
//
//                                                 onPressed: walletVM.isLoading ? null : _handleWeb3Login,
//                                               );
//                                             },
//                                           ),
//
//
//                                         ],
//                                       ),
//
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//
//                         SizedBox(height: screenHeight * 0.02),
//
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//
//   Widget _headerSection(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     return SizedBox(
//       width: screenWidth,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.center,
//          children: [
//
//           Image.asset(
//             'assets/images/applyForLisitngImg1.png',
//             height: screenHeight * 0.05,
//             fit: BoxFit.contain,
//           ),
//
//           SizedBox(height: screenHeight * 0.01),
//           Text(
//             'Sign in to your \nAccount',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: const Color(0xFFEEEEEE),
//               fontSize: screenHeight * 0.036,
//               fontFamily: 'Poppins',
//               fontWeight: FontWeight.bold,
//               height:1.3,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
// }
class _SignInState extends State<SignIn> {

  static String _sigKey(String address) => 'web3_sig_$address';
  static String _msgKey(String address) => 'web3_msg_$address';

  Future<String?> _getSavedSignature(String address) async {
    final prefs = await SharedPreferences.getInstance();
    final savedSig = prefs.getString(_sigKey(address));
    final savedMsg = prefs.getString(_msgKey(address));
    final expectedMsg = _generateSignatureMessage(address);
    if (savedSig != null && savedMsg == expectedMsg) return savedSig;
    return null;
  }

  Future<void> _saveSignature(String address, String message, String signature) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sigKey(address), signature);
    await prefs.setString(_msgKey(address), message);
  }


  TextEditingController userNameOrIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool _isNavigating = false;

  String _generateSignatureMessage(String address) {
    return [
      "Welcome to MyCoinPoll!",
      "",
      "Signing confirms wallet ownership and agreement to our terms. No transaction or fees involved—authentication only.",
      "",
      "Wallet: $address",
      "",
      "Thank you for being a part of our community!"
    ].join("\n");
  }

  @override
  void initState() {
    super.initState();
     WidgetsBinding.instance.addPostFrameCallback((_) async {
      final walletVM = Provider.of<WalletViewModel>(context, listen: false);
      await walletVM.init(context);
    });
  }

   Future<void> login() async {
    final username = userNameOrIdController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {

      ToastMessage.show(
        message: "Please fill in all fields",
        subtitle: "Username or Password is empty",
        type: MessageType.info,
        duration: CustomToastLength.LONG,
        gravity: CustomToastGravity.BOTTOM,
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await ApiService().login(username, password);
      print('Logged in as: ${response.user.name}, Token: ${response.token}');

      /// Save token + user data to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', response.token);
      await prefs.setString('user', jsonEncode(response.user.toJson()));

      /// Update user provider manually
      final userAuth = Provider.of<UserAuthProvider>(context, listen: false);
      await userAuth.loadUserFromPrefs();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardBottomNavBar()),
      );
    } catch (e) {
      ToastMessage.show(
        message: "Login Failed",
        subtitle: "Invalid credentials or server error. Please try again.",
        type: MessageType.error,
        duration: CustomToastLength.LONG,
        gravity: CustomToastGravity.BOTTOM,
      );
      print("Login error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  /// Handles the entire Web3 login flow.
  Future<void> _handleWeb3Login() async {
    if (_isNavigating) return;
    setState(() => _isNavigating = true);

    final walletVM = Provider.of<WalletViewModel>(context, listen: false);

    try {
      if (!walletVM.isConnected) {
        final ok = await walletVM.connectWallet(context);
        if (!ok) return;
      }

      // If connection fails or is cancelled, exit the flow
      if (!walletVM.isConnected || walletVM.appKitModal?.session == null) {
        ToastMessage.show(message: "Connection cancelled", subtitle: "Wallet connection is required to proceed.", type: MessageType.info);
        return;
      }

      final address = walletVM.walletAddress;
      final message = _generateSignatureMessage(address);

      final savedSig = await _getSavedSignature(address);
      if(savedSig != null){
        try{
          final response = await ApiService().web3Login(context, message, address, savedSig);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', response.token);
          await prefs.setString('user', jsonEncode(response.user.toJson()));

          final userAuth = Provider.of<UserAuthProvider>(context, listen: false);
          await userAuth.loadUserFromPrefs();
          ToastMessage.show(message: "Login Successful", type: MessageType.success);
          if (!mounted) return;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const DashboardBottomNavBar()),
                (_) => false,
          );
          return;
        }catch(_){}
      }

      // The message must be hex-encoded for the personal_sign method
      final hexMessage = bytesToHex(utf8.encode(message), include0x: true);
      final signature = await walletVM.appKitModal!.request(
        topic: walletVM.appKitModal!.session!.topic,
        chainId: walletVM.appKitModal!.selectedChain!.chainId,
        request: SessionRequestParams(
          method: 'personal_sign',
          params: [hexMessage, address],
        ),
      );

      //Verify signature with your backend
      final response = await ApiService().web3Login(context,message, address, signature);
      await _saveSignature(address, message, signature);
      print('Web3 Login Success: ${response.user.name}, Token: ${response.token}');

      //Save session and navigate
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', response.token);
      await prefs.setString('user', jsonEncode(response.user.toJson()));

      final userAuth = Provider.of<UserAuthProvider>(context, listen: false);
      await userAuth.loadUserFromPrefs();

      ToastMessage.show(message: "Login Successful", type: MessageType.success);
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const DashboardBottomNavBar()),
            (_) => false,
      );

    } catch (e) {
      final errorString = e.toString().toLowerCase();
      String subtitle;

      if (errorString.contains("user rejected") || errorString.contains("user cancelled")) {
        subtitle = "You cancelled the signature request in your wallet.";
      } else {
        subtitle = "An unexpected error occurred. Please try again.";
        print("Web3 Login Error: $e");
      }

      ToastMessage.show(
        message: "Login Failed",
        subtitle: subtitle,
        type: MessageType.error,
        duration: CustomToastLength.LONG,
      );
    } finally {
      if (mounted) setState(() => _isNavigating = false);
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
      // extendBodyBehindAppBar: true,
      // backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: const BoxDecoration(
            color: Color(0xFF01090B),
            image: DecorationImage(
              image: AssetImage('assets/images/starGradientBg.png'),
              fit: BoxFit.cover,
              alignment: Alignment.topRight,
            ),
          ),
          child: Column(
            children: [
              // SizedBox(height: screenHeight * 0.01),

              ///Back Button
              widget.showBackButton ? Align(
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
              ) : const SizedBox.shrink(),
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
                                    image: AssetImage('assets/images/longinContainer.png'),
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

                                              final isConnected = walletVM.isConnected;

                                              return BlockButtonV2(
                                                text: isConnected ? 'Go To Dashboard' : 'Connect Wallet',
                                                height: screenHeight * 0.05,
                                                width: screenWidth * 0.88,

                                                onPressed: walletVM.isLoading ? null : _handleWeb3Login,
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

    return SizedBox(
      width: screenWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
         children: [

          Image.asset(
            'assets/images/applyForLisitngImg1.png',
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
