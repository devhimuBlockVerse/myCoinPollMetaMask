import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../framework/components/CardNewsComponent.dart';
import '../digital_model_screen.dart';
import '../home/home_screen.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() =>
      _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {

  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;

  final List<Map<String, String>> _trendingNews = List.generate(4, (index) => {
    'imageUrl': "assets/icons/addSourceImage.png",
    'source': "Mycoinpoll",
    'timeAgo': "47mnt ago",
    'headline': "Trump crypto soars as president offers dinner to top holders...",
  });


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;



    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'News',
          style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 20),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        top: false,
        child: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: BoxDecoration(
            color: const Color(0xFF01090B),
            image: DecorationImage(
              image: AssetImage('assets/icons/gradientBgImage.png'),
              fit: BoxFit.contain,
              alignment: Alignment.topRight,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: screenHeight * 0.06),

                  ///Trending Section
                  _buildTrendingSection(),



                  SizedBox(height: screenHeight * 0.06),
                  ///Grid View News Section

                ],
              ),
            ),
          ),
        ),
      ),
     );
  }


  Widget _buildTrendingSection() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = screenHeight > screenWidth;
    final baseSize = isPortrait ? screenWidth : screenHeight;

    double dotSize = baseSize * 0.025; // Responsive dot size

    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Trending Text
          Text(
            'Trending',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: baseSize * 0.045,
              height: 1.2,
              color: Colors.white,
            ),
          ),

          SizedBox(height: screenHeight * 0.02),

          // Card View with Fade and Scale
          SizedBox(
            height: screenHeight * 0.28,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _trendingNews.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    double value = 1.0;
                    if (_pageController.position.haveDimensions) {
                      value = (_pageController.page! - index).abs();
                    }

                    final scale = (1 - (value * 0.7)).clamp(0.8, 1.0);
                    final opacity = (1 - (value * 0.5)).clamp(0.5, 1.0);

                    return Center(
                      child: Opacity(
                        opacity: opacity,
                        child: Transform.scale(
                          scale: Curves.easeOut.transform(scale),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                            child: CardNewsComponent(
                              imageUrl: _trendingNews[index]['imageUrl']!,
                              source: _trendingNews[index]['source']!,
                              timeAgo: _trendingNews[index]['timeAgo']!,
                              headline: _trendingNews[index]['headline']!,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // SizedBox(height: screenHeight * 0.015), // Spacing between card and dots

          // Dot Indicator
          SizedBox(
            height: dotSize + 10, // slightly more than dot size
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _trendingNews.length,
                    (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: dotSize * 0.3),
                  width: dotSize,
                  height: dotSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }



}


