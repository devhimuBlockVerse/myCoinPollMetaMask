import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../framework/components/BlockButton.dart';

class ValidationScreen extends StatefulWidget {
  const ValidationScreen({super.key});

  @override
  State<ValidationScreen> createState() => _ValidationScreenState();
}

class _ValidationScreenState extends State<ValidationScreen> {

  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers =
  List.generate(4, (_) => TextEditingController());

  Timer? _timer;
  int _secondsRemaining = 20;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    setState(() {
      _secondsRemaining = 20;
      _canResend = false;
    });

    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }
  void _validateAndSubmit() {
    if (_formKey.currentState!.validate()) {
      String code = _controllers.map((c) => c.text).join();
      print("Entered Code: $code");
      // Perform verification logic Later
    }
  }

  String _formatTime(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$mins : $secs";
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
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


                        SizedBox(height: screenHeight * 0.02),

                        // _timerButton(),

                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(4,
                                    (index) => Padding(
                                  padding: EdgeInsets.only(right: index != 3 ? baseSize * 0.025 : 0),
                                  child: _buildInputBox(index),
                                ),
                              ),
                            ),
                            SizedBox(height: baseSize * 0.04),

                            // Timer and Resend Button
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  _formatTime(_secondsRemaining),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF77798D),
                                    fontSize: baseSize * 0.035, // scalable
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                SizedBox(height: baseSize * 0.03),
                                GestureDetector(
                                  onTap: _canResend
                                      ? () {
                                    _startCountdown();
                                    print("Code resent");
                                  }
                                      : null,
                                  child: Text(
                                    'Resend Code',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: _canResend ? Color(0xFFFFF5ED) : Colors.redAccent,
                                      fontSize: baseSize * 0.04,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      decoration: _canResend ? TextDecoration.underline : null,
                                    ),
                                  ),
                                ),



                                BlockButton(
                                  height: screenHeight * 0.05,
                                  width: screenWidth * 0.88,
                                  label: 'Verify',
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
                                    _validateAndSubmit();
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(builder: (context) => ValidationScreen()),
                                    // );
                                  },
                                ),
                              ],
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

   Widget _buildInputBox(int index) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = screenHeight > screenWidth;
    final baseSize = isPortrait ? screenWidth : screenHeight;

    return Container(
      width: baseSize * 0.15,
      height: baseSize * 0.15,
      alignment: Alignment.center,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: Colors.white.withOpacity(0.5),
          ),
          borderRadius: BorderRadius.circular(baseSize * 0.02),
        ),
      ),
      child: TextFormField(
        controller: _controllers[index],
        textAlign: TextAlign.center,
        maxLength: 1,
        style: TextStyle(
          color: Colors.white,
          fontSize: baseSize * 0.05,
          fontFamily: 'Poppins',
        ),
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '';
          }
          return null;
        },
        onChanged: (value) {
          if (value.isNotEmpty && index < _controllers.length - 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }




}







