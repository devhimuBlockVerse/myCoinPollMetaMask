import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:video_player/video_player.dart';


class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final isPortrait = screenHeight > screenWidth;
    final baseSize = isPortrait ? screenWidth : screenHeight;


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
              image: AssetImage('assets/icons/starGradientBg.png'),
              fit: BoxFit.cover,
              alignment: Alignment.topRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              SizedBox(height: screenHeight * 0.01),

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
                        'Lesson',
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
                  SizedBox(width: screenWidth * 0.12),
                ],
              ),

              SizedBox(height: screenHeight * 0.01),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.01,
                  ),
                  child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          _headerSection(context),

                          SizedBox(height: screenHeight * 0.03),
                          Frame1321314897(),

                          SizedBox(height: screenHeight * 0.03),

                          _disclaimerSection(),

                          SizedBox(height: screenHeight * 0.03),


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



  Widget _headerSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth,
      height: screenHeight * 0.16,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/icons/lessonHeaderBg.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.035,
          vertical: screenHeight * 0.015,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: AutoSizeText(
                      'Blockchain Basics & Analysis',
                      style: TextStyle(
                        color: const Color(0xFFFFF5ED),
                        fontFamily: 'Poppins',
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),

                  Flexible(
                    child: AutoSizeText(
                      'Explore how blockchain transforms industries with secure and transparent data handling.',
                      style: TextStyle(
                        color: const Color(0xFFFFF5ED),
                        fontFamily: 'Poppins',
                        fontSize: screenWidth * 0.032,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 2,
              child: Image.asset(
                'assets/icons/lessonHeaderImg.png',
                height: screenHeight * 0.12,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _disclaimerSection(){
    final screenWidth = MediaQuery.of(context).size.width;
    final baseSize = screenWidth / 375; // base size for scaling fonts and paddings

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: baseSize * 15,
        vertical: baseSize * 10,
      ),
      decoration: ShapeDecoration(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFF2B2D40)),
          borderRadius: BorderRadius.circular(baseSize * 8),
        ),

      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: baseSize * 27,
            height: baseSize * 27,
            child: SvgPicture.asset(
              'assets/icons/warningIcon.svg',
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(width: baseSize * 15),
          Expanded(
            child: AutoSizeText.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text:
                    'Disclaimer and Risk Warning: This content is for educational purposes only and not financial advice. Digital assets are volatile; invest at your own risk. Binance Academy is not liable for any losses. For more information, see our ',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: baseSize * 11,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Poppins',
                      height: 1.6,
                      letterSpacing: -0.5,
                    ),
                  ),
                  TextSpan(
                    text: 'Terms of Use',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: baseSize * 11,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Poppins',
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,

                      height: 1.6,
                      letterSpacing: -0.5,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                       },
                  ),
                  TextSpan(
                    text: ' and ',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: baseSize * 11,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Poppins',
                      height: 1.6,
                      letterSpacing: -0.5,
                    ),
                  ),
                  TextSpan(
                    text: 'Risk Warning',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: baseSize * 11,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Poppins',
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                      height: 1.6,
                      letterSpacing: -0.5,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                       },
                  ),
                  TextSpan(
                    text: '.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: baseSize * 11,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Poppins',
                      height: 1.6,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.justify,
              minFontSize: 8,
              maxFontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}



// class Frame1321314897 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           width: 297,
//           height: 181.06,
//           padding: const EdgeInsets.all(16),
//           decoration: ShapeDecoration(
//             color: Color(0xFF011116),
//             shape: RoundedRectangleBorder(
//               side: BorderSide(width: 1, color: Color(0xFF7074A6)),
//               borderRadius: BorderRadius.circular(3),
//             ),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 width: double.infinity,
//                 height: 149.06,
//                 decoration: ShapeDecoration(
//                   image: DecorationImage(
//                     image: NetworkImage("https://picsum.photos/265/149"),
//                     fit: BoxFit.fill,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     side: BorderSide(width: 1, color: Colors.white),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }


// A good sample video URL (HTTPS)
const String kVideoUrl = 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';
// You can replace this with your video URL from an API or other source
// const String kVideoUrl = "https://picsum.photos/265/149"; // This is an image URL, replace with a video URL

class Frame1321314897 extends StatefulWidget {
  final String videoUrl; // You can pass the video URL to the widget

  const Frame1321314897({super.key, this.videoUrl = kVideoUrl});

  @override
  State<Frame1321314897> createState() => _Frame1321314897State();
}

class _Frame1321314897State extends State<Frame1321314897> {
  late VideoPlayerController _controller;
  Future<void>? _initializeVideoPlayerFuture;
  bool _isVideoPlaying = false;

  @override
  void initState() {
    super.initState();
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    );

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      // Ensure the first frame is shown after the video is initialized,
      // even before the play button has been pressed.
      if (mounted) {
        setState(() {});
      }
    }).catchError((error) {
      // Handle initialization error
      print("Error initializing video player: $error");
      if (mounted) {
        setState(() {}); // To rebuild and show error message or fallback
      }
    });

    _controller.addListener(() {
      if (!mounted) return;
      if (_isVideoPlaying != _controller.value.isPlaying) {
        setState(() {
          _isVideoPlaying = _controller.value.isPlaying;
        });
      }
    });
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (!_controller.value.isInitialized) return;
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // The existing outer structure
    return Column(
      children: [
        Container(
          width: 297,
          height: 181.06,
          padding: const EdgeInsets.all(16), // This padding might be too much if video fills the space
          decoration: ShapeDecoration(
            color: const Color(0xFF011116),
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0xFF7074A6)),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          // We'll use a Stack to overlay play button
          child: FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done && _controller.value.isInitialized) {
                return Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    // Use an AspectRatio to display the video.
                    // The original height was 149.06. The container's inner height (181.06 - 32 padding) is 149.06.
                    // The container's inner width (297 - 32 padding) is 265.
                    SizedBox(
                      width: 297 - 32, // Adjusting for padding
                      height: 181.06 - 32, // Adjusting for padding
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        // Use the VideoPlayer widget to display the video.
                        child: VideoPlayer(_controller),
                      ),
                    ),
                    // Play/Pause button overlay
                    GestureDetector(
                      onTap: _togglePlayPause,
                      child: Container(
                        color: Colors.transparent, // Makes the whole area tappable
                        child: Center(
                          child: AnimatedOpacity(
                            opacity: _controller.value.isPlaying ? 0.0 : 1.0,
                            duration: const Duration(milliseconds: 300),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 40.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // You can also add a progress bar or other controls here
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error loading video: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                );
              }
              else {
                // If the VideoPlayerController is still initializing, show a
                // loading spinner.
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
