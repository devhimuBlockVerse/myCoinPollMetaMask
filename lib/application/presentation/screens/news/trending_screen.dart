import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycoinpoll_metamask/framework/components/customShareButton.dart';
import 'package:share_plus/share_plus.dart';

class TrendingScreen extends StatefulWidget {
  final Map<String, String> blogData;


  const TrendingScreen({super.key, required this.blogData});

  @override
  State<TrendingScreen> createState() => _TrendingScreenState();
}

class _TrendingScreenState extends State<TrendingScreen> {
  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;


    final containerWidth = screenWidth;
    final imageHeight = containerWidth * 0.58;

    double responsiveFontSize(double baseSize) => screenWidth * (baseSize / 375);

    final String title = widget.blogData['title'] ?? '';
    final String description = widget.blogData['description'] ?? '';
    final String imageUrl = widget.blogData['imageUrl'] ?? '';
    final String id = widget.blogData['id'] ?? '';


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
              filterQuality: FilterQuality.medium,

            ),
          ),
          child: Column(
            children: [
              // SizedBox(height: screenHeight * 0.01),

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
                        'Trending',
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
                  SizedBox(width: screenWidth * 0.12), // Responsive spacer for balance
                ],
              ),

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
                          children: [
                            SizedBox(height: screenHeight * 0.01),

                            Container(
                        width: screenWidth,
                         decoration: BoxDecoration(
                          // color:  Color(0xF2040C16),
                           image: const DecorationImage(
                             image: AssetImage('assets/images/newsFrame.png'),
                             fit: BoxFit.none,
                             filterQuality: FilterQuality.medium,

                           ),
                           borderRadius: BorderRadius.circular(12),
                         ),
                        child: Padding(
                          padding:  EdgeInsets.symmetric(horizontal: screenWidth * 0.05 , vertical:  screenHeight *0.03),
                          child: Column(
                            children: [

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      title,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: responsiveFontSize(15),
                                          height: 1.3,
                                          color: Colors.white
                                      ),
                                    ),
                                  ),


                                  CustomShareButton(
                                    iconPath: 'assets/icons/shareIcon.svg',
                                    color: Colors.white,
                                    onPressed: () async {
                                      final String? postId = widget.blogData['id'];

                                      // Check if the ID is valid and not an empty string
                                      if (postId != null && postId.isNotEmpty) {
                                        final String articleUrl = 'https://coinpoll.app/posts?id=$postId';
                                        final String shareMessage = '''Check out this trending news on CoinPoll! 📰${title.trim()}🔗 Read more here: $articleUrl''';

                                        await Share.share(
                                          shareMessage,
                                          subject: "Trending News from CoinPoll",
                                        );
                                      } else {
                                        // Handle the case where the ID is missing
                                        print('Warning: Article ID is missing, sharing a generic link.');
                                        final String genericShareMessage = '''
Check out CoinPoll for the latest news on blockchain and crypto! 📰
https://mycoinpoll.com/news
''';

                                        await Share.share(
                                          genericShareMessage,
                                          subject: "Trending News from CoinPoll",
                                        );
                                      }
                                    },
                                    width: screenWidth * 0.07,
                                    height: screenWidth * 0.07,
                                  ),




                                ],
                              ),
                              SizedBox(height: screenHeight * 0.02),


                              if (imageUrl.isNotEmpty)
                                Container(
                                  height: imageHeight,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                    image: DecorationImage(
                                        image: NetworkImage(imageUrl),
                                        fit: BoxFit.fill,
                                      filterQuality: FilterQuality.medium,


                                    ),
                                  ),
                                ),

                              const SizedBox(height: 25),

                              Html(
                                data: description,

                                style: {
                                  "body": Style(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.5,
                                    fontSize: FontSize(responsiveFontSize(12)),
                                    // lineHeight: LineHeight(1.5),
                                  ),

                                },


                              )

                            ],
                          ),
                        ),
                            ),


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



  String _stripHtmlTags(String htmlText) {
    final RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(exp, '');
  }


}



