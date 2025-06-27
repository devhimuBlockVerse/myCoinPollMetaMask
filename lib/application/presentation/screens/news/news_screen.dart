import 'package:flutter/material.dart';
import 'package:mycoinpoll_metamask/application/presentation/screens/news/trending_screen.dart';
import '../../../../framework/components/BlogCompoment.dart';
import '../../../../framework/components/CardNewsComponent.dart';
import '../../../data/model/blogModel.dart';

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


  late Future<List<Map<String, String>>> _trendingNewsFuture;
  late Future<List<BlogModel>> _blogListFuture;

  @override
  void initState() {
    super.initState();
    _trendingNewsFuture = fetchTrendingNews(); // cache
    _blogListFuture = fetchBlogList();// cache
  }


  Future<List<Map<String, String>>> fetchTrendingNews() async {
    await Future.delayed(const Duration(seconds: 2));
    return List.generate(
      5,
          (index) => {
        'imageUrl': "assets/icons/addSourceImage.png",
        'source': "Mycoinpoll",
        'timeAgo': "${15 + index} mins ago",
        'headline': "Crypto breaking: Headline #$index",
      },
    );
  }


  Future<List<BlogModel>> fetchBlogList() async {

    await Future.delayed(const Duration(seconds: 2));
    const description = '''
Blockchain technology is a decentralized, distributed ledger system that records transactions across multiple computers, ensuring data integrity, transparency, and security. Unlike traditional databases managed by a central authority, blockchain relies on a peer-to-peer network, making it resistant to tampering and fraud.

Key features include:

- **Decentralization**: No central authority controls the data; all participants in the network share responsibility.
- **Transparency**: All transactions are recorded on a public ledger accessible to all participants.
- **Immutability**: Once data is recorded, it cannot be altered without consensus from the network.
- **Security**: Transactions are secured through cryptographic algorithms.
- **Smart Contracts**: Self-executing contracts with predefined rules that automate processes.

Key features include:

- **Decentralization**: No central authority controls the data; all participants in the network share responsibility.
- **Transparency**: All transactions are recorded on a public ledger accessible to all participants.
- **Immutability**: Once data is recorded, it cannot be altered without consensus from the network.
- **Security**: Transactions are secured through cryptographic algorithms.
- **Smart Contracts**: Self-executing contracts with predefined rules that automate processes.
Key features include:

- **Decentralization**: No central authority controls the data; all participants in the network share responsibility.
- **Transparency**: All transactions are recorded on a public ledger accessible to all participants.
- **Immutability**: Once data is recorded, it cannot be altered without consensus from the network.
- **Security**: Transactions are secured through cryptographic algorithms.
- **Smart Contracts**: Self-executing contracts with predefined rules that automate processes.
Key features include:

- **Decentralization**: No central authority controls the data; all participants in the network share responsibility.
- **Transparency**: All transactions are recorded on a public ledger accessible to all participants.
- **Immutability**: Once data is recorded, it cannot be altered without consensus from the network.
- **Security**: Transactions are secured through cryptographic algorithms.
- **Smart Contracts**: Self-executing contracts with predefined rules that automate processes.
Key features include:

- **Decentralization**: No central authority controls the data; all participants in the network share responsibility.
- **Transparency**: All transactions are recorded on a public ledger accessible to all participants.
- **Immutability**: Once data is recorded, it cannot be altered without consensus from the network.
- **Security**: Transactions are secured through cryptographic algorithms.
- **Smart Contracts**: Self-executing contracts with predefined rules that automate processes.
Key features include:

- **Decentralization**: No central authority controls the data; all participants in the network share responsibility.
- **Transparency**: All transactions are recorded on a public ledger accessible to all participants.
- **Immutability**: Once data is recorded, it cannot be altered without consensus from the network.
- **Security**: Transactions are secured through cryptographic algorithms.
- **Smart Contracts**: Self-executing contracts with predefined rules that automate processes.


Blockchain's applications extend beyond cryptocurrencies. In finance, it streamlines processes by eliminating intermediaries, reducing costs, and increasing transaction speed. Supply chains benefit from enhanced traceability and transparency, ensuring product authenticity and reducing fraud. In healthcare, blockchain can securely store patient records, ensuring data integrity and privacy.

Despite its advantages, blockchain faces challenges such as scalability issues and energy consumption concerns, especially with consensus mechanisms like Proof of Work. However, ongoing developments, including the adoption of Proof of Stake, aim to address these challenges, making blockchain a transformative technology across various industries.
''';

    return List.generate(
      50,
          (index) => BlogModel(
        imageUrl: 'https://picsum.photos/id/${index + 30}/200/300',
        source: 'mycoinpoll',
        date: 'Oct ${20 + index % 10}, 2024',
        title: 'Understanding Blockchain: The Backbone of Cryptocurrencies',
        description: description,
      ),
    );
  }


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
      backgroundColor: Colors.transparent,

      body: SafeArea(
        top: false,
        child: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: const BoxDecoration(
            color: Color(0xFF01090B),
            image: DecorationImage(
              // image: AssetImage('assets/icons/gradientBgImage.png'),
              // fit: BoxFit.contain,
              image: AssetImage('assets/icons/starGradientBg.png'),
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

                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: screenHeight * 0.01),

                          ///Trending Section
                          RepaintBoundary(child: _buildTrendingSection()),

                          SizedBox(height: screenHeight * 0.02),

                          ///Grid View News Section

                          RepaintBoundary(child: _buildGridViewSection()),
                        ],
                      ),
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

  Widget _buildTrendingSection() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = screenHeight > screenWidth;
    final baseSize = isPortrait ? screenWidth : screenHeight;
    double dotSize = baseSize * 0.025;

    return FutureBuilder<List<Map<String, String>>>(
      future: _trendingNewsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}", style: TextStyle(color: Colors.red)));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No trending news found", style: TextStyle(color: Colors.white)));
        }

        final trendingNews = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.all(1.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

              SizedBox(
                height: screenHeight * 0.28,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: trendingNews.length,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
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
                                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                                child: CardNewsComponent(
                                  imageUrl: news['imageUrl']!,
                                  source: news['source']!,
                                  timeAgo: news['timeAgo']!,
                                  headline: news['headline']!,
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
      },
    );
  }


  Widget _buildGridViewSection() {


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
                onPressed: () {
                  setState(() {
                  _showAllBlogs = true;
                });
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
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
        SizedBox(height: screenHeight * 0.02),

        /// ✅ Add a tiny spacing to control vertical gap
        // GridView section

        SizedBox(
          width: double.infinity,
          child: FutureBuilder<List<BlogModel>>(
            // future: fetchBlogList(),
            future:_blogListFuture,
            builder: (context , snapshot){

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Colors.white));
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.red)));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No data found", style: TextStyle(color: Colors.white)));
              }

               final fullList = snapshot.data!;
              final blogsToShow = _showAllBlogs ? fullList : fullList.take(10).toList();

              return GridView.builder(
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
                    imageUrl: blog.imageUrl,
                    source: blog.source,
                    date: blog.date,
                    title: blog.title,
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                           builder: (_) => TrendingScreen(
                              blogData: {
                                'imageUrl': blog.imageUrl,
                                'source': blog.source,
                                'date': blog.date,
                                'title': blog.title,
                                'description': blog.description,
                              },
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            }
          ),
        ),
      ],
    );
  }



}



