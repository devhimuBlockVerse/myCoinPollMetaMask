import 'package:flutter/material.dart';
import 'package:mycoinpoll_metamask/application/presentation/screens/news/trending_screen.dart';

import '../../../../framework/components/BlogCompoment.dart';
import '../../../../framework/components/CardNewsComponent.dart';
import '../../../data/services/BlogServices.dart';
import '../../../domain/model/RssModel.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() =>
      _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final PageController _pageController =
      PageController(viewportFraction: 0.9);
  int _currentPage = 0;

  final List<Map<String, String>> _trendingNews =
      List.generate(
          4,
          (index) => {
                'imageUrl':
                    "assets/icons/addSourceImage.png",
                'source': "Mycoinpoll",
                'timeAgo': "47mnt ago",
                'headline':
                    "Trump crypto soars as president offers dinner to top holders...",
              });

  // late Future<List<Map<String, String>>> _blogs;

  final BlogService blogService = BlogService();
  List<BlogPost> _blogPosts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // _blogs = BlogService().fetchBlogData();

    blogService.fetchPosts().then((posts) {
      setState(() {
        _blogPosts = posts;
      });
    }).catchError((e) {
      print("Error fetching posts: $e");
    });

   }

  String getValidImageUrl(
      Map<String, String> blog) {
    final url = blog['imageUrl'];
    if (url == null ||
        url.isEmpty ||
        !url.startsWith('http')) {
      return 'https://via.placeholder.com/200x300.png?text=No+Image';
    }
    return url;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth =
        MediaQuery.of(context).size.width;
    final screenHeight =
        MediaQuery.of(context).size.height;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

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
              image: AssetImage(
                  'assets/icons/gradientBgImage.png'),
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
                crossAxisAlignment:
                    CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      height:
                          screenHeight * 0.06),

                  ///Trending Section
                  _buildTrendingSection(),

                  SizedBox(
                      height:
                          screenHeight * 0.02),

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
    double screenWidth =
        MediaQuery.of(context).size.width;
    double screenHeight =
        MediaQuery.of(context).size.height;
    final isPortrait = screenHeight > screenWidth;
    final baseSize =
        isPortrait ? screenWidth : screenHeight;

    double dotSize =
        baseSize * 0.025; // Responsive dot size

    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
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
                setState(
                    () => _currentPage = index);
              },
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    double value = 1.0;
                    if (_pageController.position
                        .haveDimensions) {
                      value =
                          (_pageController.page! -
                                  index)
                              .abs();
                    }

                    final scale =
                        (1 - (value * 0.7))
                            .clamp(0.8, 1.0);
                    final opacity =
                        (1 - (value * 0.5))
                            .clamp(0.5, 1.0);

                    return Center(
                      child: Opacity(
                        opacity: opacity,
                        child: Transform.scale(
                          scale: Curves.easeOut
                              .transform(scale),
                          child: Padding(
                            padding: EdgeInsets
                                .symmetric(
                                    horizontal:
                                        screenWidth *
                                            0.02),
                            child:
                                CardNewsComponent(
                              imageUrl:
                                  _trendingNews[
                                          index][
                                      'imageUrl']!,
                              source:
                                  _trendingNews[
                                          index]
                                      ['source']!,
                              timeAgo:
                                  _trendingNews[
                                          index][
                                      'timeAgo']!,
                              headline:
                                  _trendingNews[
                                          index][
                                      'headline']!,
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
            height: dotSize +
                10, // slightly more than dot size
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: List.generate(
                _trendingNews.length,
                (index) => Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: dotSize * 0.3),
                  width: dotSize,
                  height: dotSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? Colors.white
                        : Colors.white
                            .withOpacity(0.3),
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

  Widget _buildGridViewSection() {
    double screenWidth =
        MediaQuery.of(context).size.width;
    double screenHeight =
        MediaQuery.of(context).size.height;
    final isPortrait = screenHeight > screenWidth;
    final baseSize =
        isPortrait ? screenWidth : screenHeight;
    //
    final int crossAxisCount = screenWidth > 900
        ? 4
        : screenWidth > 600
            ? 3
            : 2;

    final double aspectRatio =
        isPortrait ? 166 / 216 : 180 / 200;
    final crossAxisSpacing = baseSize * 0.03;
    final mainAxisSpacing = baseSize * 0.015;

    final verticalSpacing = baseSize * 0.02;

    final List<Map<String, String>> blogList =
        List.generate(
            20,
            (index) => {
                  'imageUrl':
                      'https://picsum.photos/id/${index + 30}/200/300',
                  'source': 'mycoinpoll',
                  'date':
                      'Oct ${20 + index % 10}, 2024',
                  'title':
                      'Understanding Blockchain: The Backbone of Crypto #$index',
                });

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
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
                'Running Tokens',
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
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size(0, 0),
                  tapTargetSize:
                      MaterialTapTargetSize
                          .shrinkWrap,
                ),
                child: Text(
                  textAlign: TextAlign.end,
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

        //     FutureBuilder<List<Map<String, String>>>(
        //       future: _blogs,
        //       builder: (context, snapshot) {
        //         if (snapshot.connectionState == ConnectionState.waiting) {
        //           return const Center(child: CircularProgressIndicator());
        //         } else if (snapshot.hasError) {
        //           return Center(child: Text('Error: ${snapshot.error}'));
        //         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        //           return const Center(child: Text('No blog posts found.'));
        //         }
        //         final blogs = snapshot.data!;
        //
        //         return Container(
        //         width: double.infinity,
        //         child: GridView.builder(
        //           itemCount: blogs.length,
        //           shrinkWrap: true,
        //           physics: const NeverScrollableScrollPhysics(),
        //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //             crossAxisCount: crossAxisCount,
        //             crossAxisSpacing: crossAxisSpacing,
        //             mainAxisSpacing: mainAxisSpacing,
        //             childAspectRatio: aspectRatio,
        //
        //           ),
        //           itemBuilder: (context, index) {
        //             final blog = blogs[index];
        //             // String getValidImageUrl(Map<String, String> blog) {
        //             //   final url = blog['imageUrl'];
        //             //   if (url == null || url.isEmpty || !url.startsWith('http')) {
        //             //     return 'https://via.placeholder.com/200x300.png?text=No+Image';
        //             //   }
        //             //   return url;
        //             // }
        //
        //             return Blog(
        //
        //               // imageUrl: blog['src'] ?? '', // Provide fallback
        //               imageUrl: getValidImageUrl(blog), // ✅ Use validated URL
        //               source: blog['src'] ?? '',
        //               date: blog['pubDate'] ?? '',
        //               title: blog['title'] ?? '',
        //               onTap: (){
        //                 Navigator.push(
        //                   context,
        //                   MaterialPageRoute(
        //                     builder: (_) => TrendingScreen(
        //                       blogData: blog,
        //                     ),
        //                   ),
        //                 );
        //               },
        //             );
        //           },
        //         ),
        //       );
        //
        //
        //
        //   },
        // ),


      /// ✅ Add a tiny spacing to control vertical gap
// SizedBox(height: verticalSpacing * 0),

// GridView section
        Container(
  width: double.infinity,
  child: GridView.builder(
    // itemCount: blogList.length,
    itemCount: _blogPosts.length,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: crossAxisSpacing,
      mainAxisSpacing: mainAxisSpacing,
      childAspectRatio: aspectRatio,

    ),
    itemBuilder: (context, index) {
      // final blog = blogList[index];
      final post = _blogPosts[index];

      return Blog(
        imageUrl: post.image ?? '',
        source: post.source,
        date: post.publishedAt,
        title: post.title,
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TrendingScreen(
                blogData: _blogPosts[index],
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

// ✅ Add a tiny spacing to control vertical gap
// SizedBox(height: verticalSpacing * 0),

// GridView section
// Container(
//   width: double.infinity,
//   child: GridView.builder(
//     itemCount: blogList.length,
//     shrinkWrap: true,
//     physics: const NeverScrollableScrollPhysics(),
//     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//       crossAxisCount: crossAxisCount,
//       crossAxisSpacing: crossAxisSpacing,
//       mainAxisSpacing: mainAxisSpacing,
//       childAspectRatio: aspectRatio,
//
//     ),
//     itemBuilder: (context, index) {
//       final blog = blogList[index];
//       return Blog(
//         imageUrl: blog['imageUrl']!,
//         source: blog['source']!,
//         date: blog['date']!,
//         title: blog['title']!,
//         onTap: (){
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => TrendingScreen(
//                 blogData: blog,
//               ),
//             ),
//           );
//         },
//       );
//     },
//   ),
// ),
