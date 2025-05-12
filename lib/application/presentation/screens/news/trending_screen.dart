import 'package:flutter/material.dart';
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
    final imageHeight = containerWidth * 0.48;

    double responsiveFontSize(double baseSize) => screenWidth * (baseSize / 375);

    final String title = widget.blogData['title'] ?? '';
    final String description = widget.blogData['description'] ?? ''; // here will be full description for the blog or news
    final String imageUrl = widget.blogData['imageUrl'] ?? '';


    return  Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor:  Colors.transparent,
      body: SafeArea(
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
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.01),

              Row(
                // crossAxisAlignment: CrossAxisAlignment.center,
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
                        'Trending News',
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
                  child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: screenHeight * 0.01),

                          Container(
                      width: screenWidth,
                       decoration: BoxDecoration(
                        // color:  Color(0xF2040C16),
                         image: DecorationImage(
                           image: AssetImage('assets/icons/newsFrame.png'),
                           fit: BoxFit.none,
                         ),
                         borderRadius: BorderRadius.circular(12),
                       ),
                      child: Padding(
                        padding:  EdgeInsets.symmetric(horizontal: screenWidth * 0.05 , vertical:  screenHeight *0.03),
                        child: Column(
                          children: [

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                  iconPath:'assets/icons/shareIcon.svg',
                                  color: Colors.white,
                                  onPressed: ()=> Share.share(
                                    // Replace the imageUrl with the actual URL/Src link (In Future)
                                    '$imageUrl\n\n$title\n\n$description',
                                    subject: title,

                                  ),
                                  width: screenWidth * 0.07,
                                  height: screenWidth * 0.07,
                                )

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
                                      fit: BoxFit.fill
                                  ),
                                ),
                              ),

                            const SizedBox(height: 20),


                            Text(
                              _stripHtmlTags(description),
                              style:  TextStyle(
                                  fontWeight: FontWeight.w400, // Regular
                                  fontSize: responsiveFontSize(12),
                                  height: 1.6, // 130% line height
                                  color: Colors.white
                              ),
                            ),

                          ],
                        ),
                      ),
                          ),


                        ],
                      )
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

