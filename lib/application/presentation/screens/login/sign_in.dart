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
import '../../viewmodel/bottom_nav_provider.dart';
import '../../viewmodel/user_auth_provider.dart';
import '../../viewmodel/wallet_view_model.dart';
import 'forgot_password.dart';

class SignIn extends StatefulWidget {
  final bool showBackButton;

  const SignIn({super.key, this.showBackButton = true});

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
      print(
          "WalletViewModel.isConnected: ${walletVM.isConnected}, SharedPref: $wasConnected");
    });
  }

  String _resolveAddressFromSession(
      ReownAppKitModal? modal, String? chainId, String current) {
    if (current.isNotEmpty) return current;
    final session = modal?.session;
    if (session == null) return '';

    // Try exact chain match first: eip155:<chainId>:<address>
    if (chainId != null) {
      final exact =
          session.namespaces!.values.expand((ns) => ns.accounts).firstWhere(
                (a) => a.toLowerCase().startsWith('${chainId.toLowerCase()}:'),
                orElse: () => '',
              );
      if (exact.isNotEmpty) {
        final parts = exact.split(':');
        if (parts.length >= 3) return parts.last;
      }
    }

    // Fallback: first account in any namespace
    final any = session.namespaces!.values.expand((ns) => ns.accounts).toList();
    if (any.isNotEmpty) {
      final parts = any.first.split(':');
      if (parts.length >= 3) return parts.last;
    }
    return '';
  }

  String _generateSignatureMessage(String? address) {
    final safeAddress = address ?? 'Unknown Wallet';
    debugPrint('Generating signature message for address: $safeAddress');

    return [
      "Welcome to MyCoinPoll!",
      "",
      "Signing confirms wallet ownership and agreement to our terms. No transaction or fees involved—authentication only.",
      "",
      "Wallet: $safeAddress",
      "",
      "Thank you for being a part of our community!"
    ].join("\n");
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

      /// Save token + user data to SharedPreferences
      final prefs = await SharedPreferences.getInstance();

      // credential-based auth to avoid conflict with web3
      await prefs.setString('auth_method', 'password');

      await prefs.setString('token', response.token);
      await prefs.setString('user', jsonEncode(response.user.toJson()));
      await prefs.setString('firstName', response.user.name);
      await prefs.setString('userName', response.user.username);
      await prefs.setString('emailAddress', response.user.email);
      await prefs.setString('phoneNumber', response.user.phone);
      await prefs.setString('ethAddress', response.user.ethAddress);
      await prefs.setString('unique_id', response.user.uniqueId);
      if ((response.user.image).isNotEmpty) {
        await prefs.setString('profileImage', response.user.image);
      }

      // /// Update user provider
      final userAuth = Provider.of<UserAuthProvider>(context, listen: false);
      await userAuth.loadUserFromPrefs();

      Provider.of<BottomNavProvider>(context, listen: false)
          .setFullName(response.user.name);

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
    if (!mounted) return;
    setState(() => _isNavigating = true);

    final walletVM = Provider.of<WalletViewModel>(context, listen: false);

    try {
      await walletVM.ensureModalWithValidContext(context);

      if (!walletVM.isConnected) {
        await walletVM.connectWallet(context);
      }

      if (walletVM.appKitModal?.session == null) {
        if (!mounted) return;
        ToastMessage.show(
            message: "Connection cancelled",
            subtitle: "Wallet connection is required to proceed.",
            type: MessageType.info);
        setState(() => _isNavigating = false);
        return;
      }

      // final walletAddress = walletVM.walletAddress;
      // Validate chain ID
      final chainId = walletVM.getChainIdForRequests();
      if (chainId == null) {
        if (!mounted) return;
        ToastMessage.show(
          message: "Chain Error",
          subtitle: "No chain selected. Please select a network.",
          type: MessageType.error,
        );
        setState(() => _isNavigating = false);
        return;
      }

      //Generate message and request signature

      String walletAddress = _resolveAddressFromSession(
        walletVM.appKitModal,
        chainId,
        walletVM.walletAddress,
      );
      debugPrint(' walletAdress Before personal_sign :  $walletAddress');

      // final message = _generateSignatureMessage(walletVM.walletAddress);
      final message = _generateSignatureMessage(walletAddress);
      if (message.isEmpty) {
        throw Exception("Failed to generate signature message.");
      }
      final hexMessage = bytesToHex(utf8.encode(message), include0x: true);
      debugPrint(
          'personal_sign request: topic=${walletVM.appKitModal!.session!.topic}, chainId=$chainId, params=[$hexMessage, $walletAddress]');

      final dynamic rawSignatureResponse = await walletVM.appKitModal!.request(
        topic: walletVM.appKitModal!.session!.topic,
        chainId: chainId,
        request: SessionRequestParams(
          method: 'personal_sign',
          params: [hexMessage, walletAddress],
        ),
      );

      debugPrint(
          'Raw signature response: $rawSignatureResponse, type: ${rawSignatureResponse.runtimeType}');

      String signatureString;
      if (rawSignatureResponse is String) {
        signatureString = rawSignatureResponse;
      } else if (rawSignatureResponse is Map<String, dynamic>) {
        if (rawSignatureResponse.containsKey('result') &&
            rawSignatureResponse['result'] is String) {
          signatureString = rawSignatureResponse['result'] as String;
        } else if (rawSignatureResponse.containsKey('signature') &&
            rawSignatureResponse['signature'] is String) {
          signatureString = rawSignatureResponse['signature'] as String;
        } else {
          throw Exception("Failed to parse signature from wallet response.");
        }
      } else {
        print(
            "Web3 Login Error: Signature response is not a String or Map: $rawSignatureResponse");
        throw Exception("Invalid signature format received from wallet.");
      }

      if (signatureString.isEmpty) {
        throw Exception("Empty signature received.");
      }

      if (!mounted) return;

      //Verify signature with your backend
      final response = await ApiService()
          .web3Login(context, message, walletAddress, signatureString);
      print(
          'Web3 Login Success: ${response.user.name}, Token: ${response.token}');

      //Save session and navigate
      final prefs = await SharedPreferences.getInstance();

      final sessionJson = walletVM.appKitModal!.session?.toJson();
      if (sessionJson != null) {
        await prefs.setString('walletSession', jsonEncode(sessionJson));
      }
      await prefs.setBool('isConnected', true);
      await prefs.setString('walletAddress', walletVM.walletAddress);

      await prefs.setString('token', response.token);
      await prefs.setString('user', jsonEncode(response.user.toJson()));
      await prefs.setString('firstName', response.user.name ?? '');
      await prefs.setString('userName', response.user.username ?? '');
      await prefs.setString('emailAddress', response.user.email ?? '');
      await prefs.setString('phoneNumber', response.user.phone ?? '');
      await prefs.setString('ethAddress', response.user.ethAddress ?? '');
      await prefs.setString('unique_id', response.user.uniqueId ?? '');
      if (response.user.image != null && response.user.image!.isNotEmpty) {
        await prefs.setString('profileImage', response.user.image!);
      }
      await prefs.setString('auth_method', 'web3');
      await prefs.setInt(
          'lastConnectionTime', DateTime.now().millisecondsSinceEpoch);

      if (!mounted) return;

      final userAuth = Provider.of<UserAuthProvider>(context, listen: false);
      await userAuth.loadUserFromPrefs();

      if (!mounted) return;
      final bottomNavProvider =
          Provider.of<BottomNavProvider>(context, listen: false);
      bottomNavProvider.setFullName(response.user.name ?? '');

      if (!mounted) return;
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

      if (errorString.contains("user rejected") ||
          errorString.contains("user cancelled")) {
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
              widget.showBackButton
                  ? Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: SvgPicture.asset('assets/icons/back_button.svg',
                            color: Colors.white,
                            width: screenWidth * 0.04,
                            height: screenWidth * 0.04),
                        onPressed: () => Navigator.pop(context),
                      ),
                    )
                  : const SizedBox.shrink(),

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
                                    image: AssetImage(
                                        'assets/images/longinContainer.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.06,
                                    vertical: screenHeight * 0.03,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        labelText:
                                            'Email or username or unique ID',
                                        height: screenHeight * 0.05,
                                        width: screenWidth * 0.88,
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
                                        width: screenWidth * 0.88,
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
                                                  builder: (context) =>
                                                      const ForgotPassword()),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          /// Login Button adn navigate to validation screen
                                          isLoading
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator())
                                              : BlockButton(
                                                  height: screenHeight * 0.05,
                                                  width: screenWidth * 0.88,
                                                  label: 'Login Now',
                                                  textStyle: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: screenWidth *
                                                        0.040 *
                                                        textScale,
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
                                                  decoration:
                                                      const BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Color(0xFF00C6FF),
                                                        Color(0xFF0072FF)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12),
                                                child: ShaderMask(
                                                  shaderCallback: (bounds) =>
                                                      const LinearGradient(
                                                    colors: [
                                                      Color(0xFF00C6FF),
                                                      Color(0xFF0072FF)
                                                    ],
                                                  ).createShader(Rect.fromLTWH(
                                                          0,
                                                          0,
                                                          bounds.width,
                                                          bounds.height)),
                                                  child: Text(
                                                    'OR',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontFamily: 'Poppins',
                                                      fontSize:
                                                          baseSize * 0.030,

                                                      color: Colors
                                                          .white, // Required for ShaderMask to apply
                                                      letterSpacing: 1,
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              // Right Gradient Line
                                              Expanded(
                                                child: Container(
                                                  height: 1.5,
                                                  decoration:
                                                      const BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Color(0xFF0072FF),
                                                        Color(0xFF00C6FF)
                                                      ],
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
                                              if (walletVM.isLoading ||
                                                  _isNavigating) {
                                                return const Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              }

                                              final isConnected =
                                                  walletVM.isConnected;

                                              return BlockButtonV2(
                                                text: isConnected
                                                    ? 'Go To Dashboard'
                                                    : 'Connect Wallet',
                                                height: screenHeight * 0.05,
                                                width: screenWidth * 0.88,
                                                onPressed: walletVM.isLoading
                                                    ? null
                                                    : _handleWeb3Login,
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
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
