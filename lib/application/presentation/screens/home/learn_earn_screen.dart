import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycoinpoll_metamask/framework/utils/dynamicFontSize.dart';
import '../../../../framework/components/LearnAndEarnComponent.dart';
import '../../../domain/constants/api_constants.dart';
import '../../models/get_lessons.dart';
import 'lesson_screen.dart';import 'package:http/http.dart' as http;



class LearnEarnScreen extends StatefulWidget {
  const LearnEarnScreen({super.key});

  @override
  State<LearnEarnScreen> createState() => _LearnEarnScreenState();
}

class _LearnEarnScreenState extends State<LearnEarnScreen> {

  late Future<List<LessonModel>> lessonsFuture;


  @override
  void initState() {
    super.initState();
    lessonsFuture = fetchLessons();
  }


  Future<List<LessonModel>> fetchLessons() async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/get-lessons');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => LessonModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load lessons');
    }
  }

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
                        'Learn & Earn',
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
                  child: FutureBuilder<List<LessonModel>>(
                    future: lessonsFuture,
                    builder: (context, snapshot) {

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator(color: Colors.white));
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error loading lessons',
                            style: TextStyle(color: Colors.red, fontSize: screenWidth * 0.04),
                          ),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text(
                            'No lessons found.',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      final lessons = snapshot.data!;


                      return ScrollConfiguration(
                        behavior: const ScrollBehavior().copyWith(overscroll: false),
                        child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                _headerSection(context),
                                SizedBox(height: screenHeight * 0.04),
                                Text(
                                  'Learn & Earn',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    fontSize: baseSize * 0.045,
                                    height: 1.2,
                                    color: Colors.white,
                                  ),
                                ),



                                SizedBox(height: screenHeight * 0.03),

                                ...lessons.map((lesson) => Padding(
                                  padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                                  child: LearnAndEarnContainer(
                                    title: lesson.title,
                                    description: lesson.shortDescription,
                                    // imagePath: lesson.image,
                                    imagePath: 'assets/images/learnAndEarnImg.png',
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => LessonScreen(lesson: lesson),
                                        ),
                                      );
                                    },
                                  ),
                                )),


                                SizedBox(height: screenHeight * 0.05),

                                _disclaimerSection(),

                                SizedBox(height: screenHeight * 0.03),


                              ],
                            )
                        ),
                      );
                    },
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
      height: screenHeight * 0.16,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bgContainerImg.png'),
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
                       'Grow Your Crypto Knowledge',
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
                      'Earn free crypto by completing short courses on blockchain, DeFi, and emerging tech.',
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
                'assets/images/headerFrameContainer.png',
                height: screenHeight * 0.12,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _disclaimerSection(){
    final screenWidth = MediaQuery.of(context).size.width;
    final baseSize = screenWidth / 375;

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




