import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../framework/components/BlockButton.dart';

class ValidationScreen extends StatefulWidget {

  final String getUserNameOrId ;
  const ValidationScreen({super.key, required this.getUserNameOrId});

  @override
  State<ValidationScreen> createState() => _ValidationScreenState();
}

class _ValidationScreenState extends State<ValidationScreen> {

  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _validationInputController =
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
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
      String code = _validationInputController.map((c) => c.text).join();
      debugPrint("Entered Code: $code");
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
    for (var controller in _validationInputController) {
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
              image: AssetImage('assets/images/starGradientBg.png'),
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
                        'Verification',
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
                  SizedBox(width: screenWidth * 0.12),
                ],
              ),

              SizedBox(height: screenHeight * 0.01),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.01,
                  ),
                  child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: screenHeight * 0.06),


                          _userEmailSection(),

                          SizedBox(height: screenHeight * 0.02),

                          /// Timer and Validation Input Code
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(4,
                                        (index) => Padding(
                                          padding: EdgeInsets.only(right: index != 3 ? baseSize * 0.080 : 0),
                                          child: _validationInputBox(index),
                                        ),
                                  ),
                                ),
                                SizedBox(height: baseSize * 0.08),

                                // Timer and Resend Button
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      _formatTime(_secondsRemaining),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: const Color(0xFF77798D),
                                        fontSize: baseSize * 0.035, // scalable
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    SizedBox(height: baseSize * 0.03),
                                    GestureDetector(
                                      onTap: _canResend
                                          ? () {
                                        _startCountdown();
                                        debugPrint("Code resent");
                                      }
                                      : null,
                                      child: Text(
                                        'Resend Code',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: _canResend ? const Color(0xFFFFF5ED) : Colors.redAccent,
                                          fontSize: baseSize * 0.04,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                          decoration: _canResend ? TextDecoration.underline : null,
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: screenHeight * 0.05),

                                    BlockButton(
                                      height: screenHeight * 0.05,
                                      width: screenWidth * 0.70,
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
                                        _validateAndSubmit();

                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _validationInputBox(int index) {
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
        controller: _validationInputController[index],
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
          if (value.isNotEmpty && index < _validationInputController.length - 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }

  Widget _userEmailSection() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = screenHeight > screenWidth;
    final baseSize = isPortrait ? screenWidth : screenHeight;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: baseSize * 0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: baseSize * 0.7,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Code has been sent to your email',
                    style: TextStyle(
                      color: const Color(0xFF77798D),
                      fontSize: baseSize * 0.035,
                      fontFamily: 'Poppins',
                      height: 1.4,
                    ),
                  ),
                  TextSpan(
                    text: '\n${widget.getUserNameOrId}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: baseSize * 0.037,
                      fontFamily: 'Poppins',
                      height: 1.4,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }





}






