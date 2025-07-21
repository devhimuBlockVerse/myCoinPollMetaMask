import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../framework/components/BlockButton.dart';
import '../../../../framework/components/ListingFields.dart';
import 'package:http/http.dart'as http;

import '../../../../framework/utils/customToastMessage.dart';
import '../../../../framework/utils/enums/toast_type.dart';


class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController uniqueIDController = TextEditingController();
  bool isLoading = false;

  Future<void> sendResetPasswordRequest() async {
    final uniqueId = uniqueIDController.text.trim();

    if (uniqueId.isEmpty) {

      ToastMessage.show(
        message: "Unique ID is required",
         type: MessageType.info,
        duration: CustomToastLength.LONG,
        gravity: CustomToastGravity.BOTTOM,
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

      final request = http.Request(
        'POST',
        Uri.parse('https://app.mycoinpoll.com/api/v1/auth/forget-password'),
      );

      request.body = json.encode({
        "unique_id": uniqueId,
      });

      request.headers.addAll(headers);

      final response = await request.send();

      if (response.statusCode == 200) {
        final result = await response.stream.bytesToString();
        debugPrint("Reset request success: $result");

        ToastMessage.show(
          message: "Reset Link Sent",
          subtitle: "Check your email for the password reset instructions.",
          type: MessageType.success,
          duration: CustomToastLength.LONG,
          gravity: CustomToastGravity.BOTTOM,
        );

        uniqueIDController.clear();
       } else {
        final error = await response.stream.bytesToString();
        print("Reset request failed: $error");


        ToastMessage.show(
          message: "Reset Failed",
          subtitle: "Server error: ${response.reasonPhrase ?? 'Please try again.'}",
          type: MessageType.error,
          duration: CustomToastLength.LONG,
          gravity: CustomToastGravity.BOTTOM,
        );
      }
    } catch (e) {
      print("Exception: $e");

      ToastMessage.show(
        message: "Request Error",
        subtitle: "Something went wrong. Please try again.",
        type: MessageType.error,
        duration: CustomToastLength.LONG,
        gravity: CustomToastGravity.BOTTOM,
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

              image: AssetImage('assets/images/starGradientBg.png'),
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
                                    image: AssetImage('assets/images/forgotpassbg.png'),
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

                                    SizedBox(
                                       child: Text(
                                        // 'Please enter your email that you use to sign up to mycoinpoll',
                                        'Please enter your Unique ID that you use to sign up to mycoinpoll',
                                        style: TextStyle(
                                          color: const Color(0xFF77798D),
                                          fontSize: baseSize * 0.035,
                                          fontFamily: 'Poppins',
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                      SizedBox(height: screenHeight * 0.02),
                                      /// Email
                                      Text(
                                        // 'Email or Username',
                                        'Enter Unique ID',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.normal,
                                          fontSize: baseSize * 0.045,
                                          height: .80,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: screenHeight * 0.02),
                                      /// Email Input Field
                                      ListingField(
                                        controller: uniqueIDController,
                                        labelText: 'Enter Unique ID',
                                        height: screenHeight * 0.05,
                                        width: screenWidth* 0.88,
                                        expandable: false,
                                        keyboard: TextInputType.name,
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
                                            label: 'Send Reset Request',
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
                                            onTap: sendResetPasswordRequest,
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

}

