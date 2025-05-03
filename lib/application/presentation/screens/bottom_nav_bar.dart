import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mycoinpoll_metamask/application/presentation/screens/androverse/androverse_screen.dart';
import 'package:mycoinpoll_metamask/application/presentation/screens/features/features_screen.dart';
import 'package:mycoinpoll_metamask/application/presentation/screens/home/home_screen.dart';
import 'package:mycoinpoll_metamask/application/presentation/screens/learnAndEarn/learn&build_screen.dart';
import 'package:mycoinpoll_metamask/application/presentation/screens/news/news_screen.dart';

import '../../../framework/res/colors.dart';

class BottomNavBar extends StatefulWidget {
  final int initialIndex;
  const BottomNavBar({super.key, this.initialIndex = 1});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> with TickerProviderStateMixin {

  int _currentIndex = 1;

  final List<Widget> _pages =[

    HomeScreen(),
    FeaturesScreen(),
    AndroVerseScreen(),
    NewsScreen(),
    LearnAndBuildScreen(),

  ];

  final List<String> _labels = ['Home', 'Features', 'Androverse','News','learn & Earn'];
  final List<String> _imgPaths =[
    'assets/icons/home.png',
    'assets/icons/features.png',
    'assets/icons/androverse.png',
    'assets/icons/news.png',
    'assets/icons/learnearn.png',

  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  void dispose() {
     super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width * 1;
    double screenHeight = MediaQuery.of(context).size.height * 1;
    return SafeArea(


        child: WillPopScope(

          onWillPop:()async{

            final value = await showDialog<bool>(

            context: context,

            builder: (context){

              return Theme(

                data: ThemeData(
                    dialogBackgroundColor: Colors.transparent

                ),
                child: AlertDialog(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.02,
                    vertical: screenHeight * 0.02,
                  ),
                  insetPadding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.1,
                    vertical: screenHeight * 0.2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  content: Text(
                    "  Are you sure you want to exit ?",
                    style: TextStyle(fontSize: 18),
                  ),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            exit(0);
                          },
                          child: Container(
                            width: screenWidth * 0.2,
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.011,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.loginButtonColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(
                                'Yes',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: screenWidth * 0.020,
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(false),
                          child: Container(
                            width: screenWidth * 0.2,
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.011,
                              // horizontal: screenWidth * 0.001
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(
                                'No',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            });
        if(value != null){
          return Future.value(value);
        }else{
          return Future.value(false);
        }
      },

      child: Scaffold(
        extendBodyBehindAppBar: true,

        backgroundColor: Colors.transparent,
        body:  _pages[_currentIndex],
        bottomNavigationBar: Container(
          height: screenHeight * 0.08,
           padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          decoration: BoxDecoration(
            color: Color(0xFF2C2E41),
             borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (index) {
              bool isSelected = _currentIndex == index;
              return InkWell(
                onTap: () {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: screenWidth*0.14,
                      child: Image.asset(
                        _imgPaths[index],
                        color: isSelected ? Color(0xFF6BB2FF) :  Color(0xFFB2B0B6),
                        height: 25,
                        width: 26,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      _labels[index],
                      style: TextStyle(
                          color: isSelected ? Color(0xFF6BB2FF) : Color(0xFFB2B0B6),
                          fontSize:isSelected ? 12:10,
                          fontWeight: isSelected ? FontWeight.bold: FontWeight.normal
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),

    ));
  }


}
