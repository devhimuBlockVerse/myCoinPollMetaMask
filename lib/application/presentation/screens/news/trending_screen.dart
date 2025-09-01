import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycoinpoll_metamask/framework/components/customShareButton.dart';
import 'package:mycoinpoll_metamask/framework/utils/dynamicFontSize.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../framework/components/badgeComponent.dart';
import '../../../../framework/components/buy_Ecm.dart';
import '../../models/news_model.dart';

class TrendingScreen extends StatefulWidget {
   final NewsModel newsModel;

  const TrendingScreen({super.key, required this.newsModel});

  @override
  State<TrendingScreen> createState() => _TrendingScreenState();
}

class _TrendingScreenState extends State<TrendingScreen> {
  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;


    final containerWidth = screenWidth;
    final imageHeight = containerWidth * 0.62;

    double responsiveFontSize(double baseSize) => screenWidth * (baseSize / 375);

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
                    horizontal: screenWidth * 0.01,
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
                          padding:  EdgeInsets.symmetric(horizontal: screenWidth * 0.07 , vertical:  screenHeight *0.03),
                          child: Column(
                            children: [

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      widget.newsModel.title,
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
                                      final String? postId = widget.newsModel.id.toString();

                                      // Check if the ID is valid and not an empty string
                                      if (postId != null && postId.isNotEmpty) {
                                        final String articleUrl = 'https://coinpoll.app/posts?id=$postId';
                                        final String shareMessage = '''Check out this trending news on CoinPoll! 📰${widget.newsModel.title.trim()}🔗 Read more here: $articleUrl''';

                                        await Share.share(
                                          shareMessage,
                                          subject: "Trending News from CoinPoll",
                                        );
                                      } else {
                                        // Handle the case where the ID is missing
                                        print('Warning: Article ID is missing, sharing a generic link.');
                                        final String genericShareMessage = '''Check out CoinPoll for the latest news on blockchain and crypto! 📰https://mycoinpoll.com/news''';

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
                              SizedBox(height: screenHeight * 0.04),

                              if (widget.newsModel.image.isNotEmpty)
                                Container(
                                  height: imageHeight,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                    image: DecorationImage(
                                        image: NetworkImage(widget.newsModel.image),
                                        fit: BoxFit.fill,
                                      filterQuality: FilterQuality.medium,


                                    ),
                                  ),
                                ),

                              const SizedBox(height: 25),

                              Html(
                                data: widget.newsModel.description,
                                style: {
                                  "body": Style(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.5,
                                    fontSize: FontSize(responsiveFontSize(12)),
                                    // lineHeight: LineHeight(0.5),
                                  ),
                                },
                              ),

                              if (widget.newsModel.externalLinks != null &&
                                  widget.newsModel.externalLinks!.isNotEmpty) ...[
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.02,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        ' ✨ We are featured in ✨ ',

                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: getResponsiveFontSize(context,16),
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Poppins',
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      SizedBox(height: screenHeight * 0.02),
                                      Wrap(
                                        spacing: 8,
                                        // spacing: screenWidth * 0.05,
                                        // runSpacing: screenHeight * 0.008,
                                        alignment: WrapAlignment.spaceBetween,
                                         direction: Axis.horizontal,
                                        textDirection: TextDirection.ltr,
                                        children: widget.newsModel.externalLinks!.map((link) {
                                          return _buildExternalLinkCard(
                                            link,
                                            screenWidth,
                                            screenHeight,
                                            responsiveFontSize,
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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

  Widget _buildExternalLinkCard(ExternalLink link, double screenWidth, double screenHeight, Function(double) responsiveFontSize) {
    return GestureDetector(
      onTap: () async {
        try {
          final Uri url = Uri.parse(link.link);
          if (await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.externalApplication);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Could not open link'),
                backgroundColor: Colors.red,
              ),
            );
          }
        } catch (e) {
         }
      },
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return const LinearGradient(
            colors: [Color(0xFF2D8EFF), Color(0xFF2EE4A4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds);
        },
        child: Chip(

          label: Text(
            link.pr,
            style:  TextStyle(
              color: Colors.white,
              fontSize: screenWidth * 0.03,
            ),
          ),
          backgroundColor: const Color(0xFF1E2638),
          side: const BorderSide(color: Colors.transparent, width: 0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
          avatar:  Icon(
            Icons.open_in_new,
            color: Colors.white,
            size: screenHeight * 0.018,
          ),
        ),
      ),
    );

  }









}



