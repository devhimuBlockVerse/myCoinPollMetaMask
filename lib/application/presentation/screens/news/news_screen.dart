import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mycoinpoll_metamask/application/presentation/screens/news/trending_screen.dart';
import '../../../../framework/components/BlogCompoment.dart';
import '../../../../framework/components/CardNewsComponent.dart';
import '../../../domain/constants/api_constants.dart';
 import '../../models/news_model.dart';
import 'package:http/http.dart'as http;

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() =>
      _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {


  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;
  bool _showAllBlogs = false;
  Timer? _autoScrollTimer;

  late Future<List<NewsModel>> _newsFuture;



  @override
  void initState() {
    super.initState();
    _newsFuture = fetchNewsData();

  }

  Future<List<NewsModel>> fetchNewsData() async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/get-news');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      print('Raw API Data: ${jsonData.firstWhere((item) => item.containsKey("id"), orElse: () => null)}');

      return jsonData.map((e) => NewsModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch news');
    }
  }

  void _startAutoScroll(int totalPages) {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        _currentPage++;
        if (_currentPage >= totalPages) {
          _currentPage = 0; // loop back to first page
        }
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();

    _pageController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;


    return Scaffold(
      // extendBodyBehindAppBar: true,
      // backgroundColor: Colors.transparent,

      body: SafeArea(
        top: false,
        child: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: const BoxDecoration(
            color: Color(0xFF01090B),
            image: DecorationImage(
              // image: AssetImage('assets/images/gradientBgImage.png'),
              // fit: BoxFit.contain,
              image: AssetImage('assets/images/starGradientBg.png'),
              fit: BoxFit.cover,
              alignment: Alignment.topRight,
              filterQuality: FilterQuality.medium,

            ),
          ),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.02),

              Align(
                alignment: Alignment.topCenter,
                child:  Text(
                  'News',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      // fontSize: 20
                    fontSize: screenWidth * 0.05,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.02,
                  ),
                  child: ScrollConfiguration(
                    behavior: const ScrollBehavior().copyWith(overscroll: false),
                    child: FutureBuilder<List<NewsModel>>(
                      future: _newsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator(color: Colors.white));
                        } else if (snapshot.hasError) {
                          print("Error: ${snapshot.error}");
                          return Center(child: Text("Error: ${snapshot.error}", style: TextStyle(color: Colors.red)));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text("No news available", style: TextStyle(color: Colors.white)));
                        }
                        final newsList = snapshot.data!;
                        final trendingNews = newsList.take(5).toList();
                        final blogsToShow = _showAllBlogs ? newsList : newsList.take(10).toList();
                        if (_autoScrollTimer == null || !_autoScrollTimer!.isActive) {
                          _startAutoScroll(trendingNews.length);
                        }
                        return SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: screenHeight * 0.01),

                              ///Trending Section
                              _buildTrendingSection(trendingNews),

                              SizedBox(height: screenHeight * 0.02),

                              ///Grid View News Section

                              _buildGridViewSection(blogsToShow),
                            ],
                          ),
                        );
                      },

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

  Widget _buildTrendingSection(List<NewsModel> trendingNews) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = screenHeight > screenWidth;
    final baseSize = isPortrait ? screenWidth : screenHeight;
    double dotSize = baseSize * 0.025;

   return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            // 'Trending',
            'Featured News',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: baseSize * 0.045,
              height: 1.2,
              color: Colors.white,
            ),
          ),

          SizedBox(height: screenHeight * 0.02),

          SizedBox(
            height: screenHeight * 0.28,
            child: PageView.builder(
              controller: _pageController,
              itemCount: trendingNews.length,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (context, index) {
                final news = trendingNews[index];

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
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.002),
                            child: CardNewsComponent(
                              imageUrl: news.image,
                              source: 'Mycoinpoll',
                              timeAgo: news.createdAt,
                              headline: news.title,

                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TrendingScreen(
                                      newsModel: news,
                                    ),
                                  ),
                                );
                              },

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

          SizedBox(height: screenHeight * 0.02),

          SizedBox(
            height: dotSize + 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                trendingNews.length,
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

          SizedBox(height: screenHeight * 0.02),
        ],
      ),
    );
  }


  Widget _buildGridViewSection(List<NewsModel> blogsToShow) {


    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = screenHeight > screenWidth;
    final baseSize = isPortrait ? screenWidth : screenHeight;

    final int crossAxisCount = screenWidth > 900 ? 4 : screenWidth > 600 ? 3 : 2;
    final double aspectRatio = isPortrait ? 166 / 216 : 180 / 200;
    final crossAxisSpacing = baseSize * 0.03;
    final mainAxisSpacing = baseSize * 0.015;


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text(
                textAlign: TextAlign.start,
                'News',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: baseSize * 0.045,
                  height: 1.2,
                  color: Colors.white,
                ),
              ),

            ],
          ),
        ),
        SizedBox(height: screenHeight * 0.02),

        /// ✅ Add a tiny spacing to control vertical gap


        SizedBox(
          width: double.infinity,
          child: GridView.builder(
            itemCount: blogsToShow.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: crossAxisSpacing,
              mainAxisSpacing: mainAxisSpacing,
              childAspectRatio: aspectRatio,

            ),
            itemBuilder: (context, index) {
              final blog = blogsToShow[index];
              return Blog(
                imageUrl: blog.image,
                source: 'Mycoinpoll',
                date: blog.createdAt,
                title: blog.title,
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TrendingScreen(
                        newsModel: blog,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }



}


