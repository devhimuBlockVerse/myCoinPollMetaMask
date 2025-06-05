import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycoinpoll_metamask/application/presentation/screens/androverse/androverse_screen.dart';
import 'package:mycoinpoll_metamask/application/presentation/screens/features/features_screen.dart';
import 'package:mycoinpoll_metamask/application/presentation/screens/home/home_screen.dart';
 import 'package:mycoinpoll_metamask/application/presentation/screens/news/news_screen.dart';
import 'package:mycoinpoll_metamask/application/presentation/screens/profile/profile_screen.dart';
import 'package:provider/provider.dart';
import '../../../framework/res/colors.dart';
import '../viewmodel/bottom_nav_provider.dart';





class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> with TickerProviderStateMixin {
  final List<Widget> _pages = [
    const HomeScreen(),
    const FeaturesScreen(),
    const AndroVerseScreen(),
    const NewsScreen(),
    const ProfileScreen(),
  ];

   final List<String> _labels = ['Home', 'Features', 'Androverse', 'News', 'Profile'];

  final List<String> _imgPaths = [
    'assets/icons/home.svg',
    'assets/icons/features.svg',
    'assets/icons/androverse.svg',
    'assets/icons/news.svg',
    'assets/icons/profileIcon.svg',
  ];

  Future<bool> _onWillPop(double screenWidth, double screenHeight) async {
    final value = await showDialog<bool>(
      context: context,
      builder: (context) {
        return Theme(
          data: ThemeData(dialogTheme: const DialogThemeData(backgroundColor: Colors.transparent)),
          child: AlertDialog(
            contentPadding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.02,
              vertical: screenHeight * 0.02,
            ),
            insetPadding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.1,
              vertical: screenHeight * 0.2,
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: const Text(
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
                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.011),
                      decoration: BoxDecoration(
                        color: AppColors.loginButtonColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Center(
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
                  SizedBox(width: screenWidth * 0.020),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(false),
                    child: Container(
                      width: screenWidth * 0.2,
                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.011),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Center(
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
      },
    );
    return value ?? false;
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width * 1;
    double screenHeight = MediaQuery.of(context).size.height * 1;

    final currentIndex = Provider.of<BottomNavProvider>(context).currentIndex;

    return SafeArea(
      child: WillPopScope(
        onWillPop: () => _onWillPop(screenWidth, screenHeight),
        child: Scaffold(

          backgroundColor: const Color(0xFF0E0F1A),

          body: _pages[currentIndex],
          // body: IndexedStack(
          //   index: currentIndex,
          //   children: _pages,
          // ),
          bottomNavigationBar: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                height: screenHeight * 0.085,
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF141521).withOpacity(0.85),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 10,
                    ),
                  ],
                  border: Border(
                    top: BorderSide(
                      color: Colors.white.withOpacity(0.05),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(5, (index) {
                    bool isSelected = currentIndex == index;
                    return InkWell(
                      onTap: () {
                        Provider.of<BottomNavProvider>(context, listen: false).setIndex(index);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: screenWidth * 0.14,
                            child: SvgPicture.asset(
                              _imgPaths[index],
                              color: isSelected ? const Color(0xFF6BB2FF) : const Color(0xFFB2B0B6),
                              height: 20,
                              width: 24,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _labels[index],
                            style: TextStyle(
                              color: isSelected ? const Color(0xFF6BB2FF) : const Color(0xFFB2B0B6),
                              fontSize: isSelected ? 12 : 10,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

