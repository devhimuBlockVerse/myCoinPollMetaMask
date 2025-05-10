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



                  SizedBox(height: screenHeight * 0.02),

                  ///Grid View News Section

                   _buildGridViewSection(),


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



  Widget _buildGridViewSection() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = screenHeight > screenWidth;
    final baseSize = isPortrait ? screenWidth : screenHeight;

    final int crossAxisCount = screenWidth > 900
        ? 4
        : screenWidth > 600
        ? 3
        : 2;

    final double aspectRatio = isPortrait ? 166 / 216 : 180 / 200;
    final crossAxisSpacing = baseSize * 0.03;
    final mainAxisSpacing = baseSize * 0.03;

    final horizontalPadding = baseSize * 0.01;
    final verticalSpacing = baseSize * 0.02;

    final List<Map<String, String>> blogList = List.generate(20, (index) => {
      'imageUrl': 'https://picsum.photos/id/${index + 30}/200/300',
      'source': 'mycoinpoll',
      'date': 'Oct ${20 + index % 10}, 2024',
      'title': 'Understanding Blockchain: The Backbone of Crypto #$index',
    });

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: verticalSpacing),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'News',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: baseSize * 0.045,
                    height: 1.2,
                    color: Colors.white,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'View All',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: baseSize * 0.038,
                      height: 1.2,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: verticalSpacing),

          /// ✅ Don't wrap GridView with Flexible or Expanded in a scroll view
          GridView.builder(
            itemCount: blogList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: crossAxisSpacing,
              mainAxisSpacing: mainAxisSpacing,
              childAspectRatio: aspectRatio,
            ),
            itemBuilder: (context, index) {
              final blog = blogList[index];
              return Blog(
                imageUrl: blog['imageUrl']!,
                source: blog['source']!,
                date: blog['date']!,
                title: blog['title']!,
              );
            },
          ),

          SizedBox(height: verticalSpacing * 2),
        ],
      ),
    );
  }

}


class Blog extends StatelessWidget {
  final String imageUrl;
  final String source;
  final String date;
  final String title;

  const Blog({
    super.key,
    required this.imageUrl,
    required this.source,
    required this.date,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double containerWidth = screenWidth * 0.42; // ~166px on 400 width
    final double imageHeight = screenHeight * 0.20;   // ~160px on 800 height
    final double padding = screenWidth * 0.02;
    final double fontSmall = screenWidth * 0.025; // ~10px on 400 width
    final double fontMedium = screenWidth * 0.028; // ~11px
    final double dotSize = screenWidth * 0.008; // ~2px

    return Container(
      width: containerWidth,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
         mainAxisAlignment: MainAxisAlignment.start,
         children: [
          Container(
            width: double.infinity,
            height: imageHeight,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(padding),
            decoration: const BoxDecoration(
              color: Color(0xFF212223),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(9.72),
                bottomRight: Radius.circular(9.72),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      source,
                      style: TextStyle(
                        color: const Color(0xFF7D8088),
                        fontSize: fontSmall,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        height: 1.6,
                      ),
                    ),
                    SizedBox(width: padding * 0.5),
                    Container(
                      width: dotSize,
                      height: dotSize,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF7D8088),
                      ),
                    ),
                    SizedBox(width: padding * 0.5),
                    Text(
                      date,
                      style: TextStyle(
                        color: const Color(0xff7E8088),
                        fontSize: fontSmall,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: padding * 0.5),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: fontMedium,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
