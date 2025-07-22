import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../framework/utils/dynamicFontSize.dart';
import '../../../../framework/widgets/video_player.dart';
import '../../models/get_lessons.dart';


class LessonScreen extends StatefulWidget {
  final LessonModel lesson;

  const LessonScreen({super.key, required this.lesson});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = screenHeight > screenWidth;
    final baseSize = isPortrait ? screenWidth : screenHeight;


    final lesson = widget.lesson;


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
                        'Lesson',
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
                  child: ScrollConfiguration(
                    behavior: const ScrollBehavior().copyWith(overscroll: false),

                    child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            _headerSection(context,lesson),

                            SizedBox(height: screenHeight * 0.03),
                             VideoPlayerService(

                              videoUrl: 'https://youtu.be/${lesson.videoId}',
                            ),



                            SizedBox(height: screenHeight * 0.03),

                            _description(lesson),

                            SizedBox(height: screenHeight * 0.03),

                            _disclaimerSection(),

                            SizedBox(height: screenHeight * 0.03),


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

  Widget _headerSection(BuildContext context, LessonModel lesson) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth,
      height: screenHeight * 0.16,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/lessonHeaderBg.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.035,
          vertical: screenHeight * 0.015,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: AutoSizeText(
                      // 'Blockchain Basics & Analysis',
                      lesson.title,
                      style: TextStyle(
                        color: const Color(0xFFFFF5ED),
                        fontFamily: 'Poppins',
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),

                  Flexible(
                    child: AutoSizeText(
                      // 'Explore how blockchain transforms industries with secure and transparent data handling.',
                      lesson.shortDescription,
                      style: TextStyle(
                        color: const Color(0xFFFFF5ED),
                        fontFamily: 'Poppins',
                        fontSize: screenWidth * 0.032,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 2,
              child: Image.asset(
                'assets/images/lessonHeaderImg.png',
                height: screenHeight * 0.12,
                fit: BoxFit.contain,
              ),
              // child: Image.network(
              //   lesson.image,
              //   height: screenHeight * 0.12,
              //   fit: BoxFit.contain,
              // ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _description(LessonModel lesson) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double titleFontSize = screenWidth * 0.032;
    double bodyFontSize = screenWidth * 0.027;

    return Center(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.014,
        ),
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage("assets/images/frameBg.png"),
            fit: BoxFit.fill,
          ),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lesson.title,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: titleFontSize,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                height: 1.6,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              _removeHtmlTags(lesson.description),
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: bodyFontSize,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.normal,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _disclaimerSection(){
    final screenWidth = MediaQuery.of(context).size.width;
    final baseSize = screenWidth / 375; // base size for scaling fonts and paddings

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: baseSize * 15,
        vertical: baseSize * 10,
      ),
      decoration: ShapeDecoration(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFF2B2D40)),
          borderRadius: BorderRadius.circular(baseSize * 8),
        ),

      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: baseSize * 27,
            height: baseSize * 27,
            child: SvgPicture.asset(
              'assets/icons/warningIcon.svg',
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(width: baseSize * 15),
          Expanded(
            child: AutoSizeText.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text:
                    'Disclaimer and Risk Warning: This content is for educational purposes only and not financial advice. Digital assets are volatile; invest at your own risk. Binance Academy is not liable for any losses. For more information, see our ',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      // fontSize: baseSize * 11,
                      fontSize: getResponsiveFontSize(context, 11),

                      fontStyle: FontStyle.italic,
                      fontFamily: 'Poppins',
                      height: 1.6,
                      letterSpacing: -0.5,
                    ),
                  ),
                  TextSpan(
                    text: 'Terms of Use',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: baseSize * 11,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Poppins',
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,

                      height: 1.6,
                      letterSpacing: -0.5,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                       },
                  ),
                  TextSpan(
                    text: ' and ',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: baseSize * 11,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Poppins',
                      height: 1.6,
                      letterSpacing: -0.5,
                    ),
                  ),
                  TextSpan(
                    text: 'Risk Warning',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: baseSize * 11,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Poppins',
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                      height: 1.6,
                      letterSpacing: -0.5,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                       },
                  ),
                  TextSpan(
                    text: '.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: baseSize * 11,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Poppins',
                      height: 1.6,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.justify,
              minFontSize: 8,
              maxFontSize: 14,
            ),
          ),
        ],
      ),
    );
  }



}

String _removeHtmlTags(String htmlText) {
  final exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
  return htmlText.replaceAll(exp, '');
}

