import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// class VideoPlayerService extends StatefulWidget {
//   final String videoUrl;
//
//   const VideoPlayerService({super.key, required this.videoUrl});
//
//   @override
//   State<VideoPlayerService> createState() => _VideoPlayerServiceState();
// }
//
// class _VideoPlayerServiceState extends State<VideoPlayerService> {
//   late VideoPlayerController _controller;
//   Future<void>? _initializeVideoPlayerFuture;
//   bool _isVideoPlaying = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
//
//     _initializeVideoPlayerFuture = _controller.initialize().then((_) {
//       if (mounted) {
//         setState(() {});
//       }
//     }).catchError((error) {
//       print("Error initializing video player: $error");
//       if (mounted) setState(() {});
//     });
//
//     _controller.addListener(() {
//       if (!mounted) return;
//       if (_isVideoPlaying != _controller.value.isPlaying) {
//         setState(() {
//           _isVideoPlaying = _controller.value.isPlaying;
//         });
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   void _togglePlayPause() {
//     if (!_controller.value.isInitialized) return;
//     setState(() {
//       _controller.value.isPlaying ? _controller.pause() : _controller.play();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//     final isLandscape = screenSize.width > screenSize.height;
//
//     // Set responsive width and height
//     final videoWidth = screenSize.width * 0.7;
//     final videoHeight = isLandscape
//         ? screenSize.height * 0.7
//         : screenSize.height * 0.2;
//
//     return Center(
//       child: Container(
//         width: videoWidth,
//         height: videoHeight,
//         padding: const EdgeInsets.all(12),
//         decoration: ShapeDecoration(
//           color: const Color(0xFF011116),
//           shape: RoundedRectangleBorder(
//             side: const BorderSide(width: 1, color: Color(0xFF7074A6)),
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//         child: FutureBuilder(
//           future: _initializeVideoPlayerFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.done &&
//                 _controller.value.isInitialized) {
//               return Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   AspectRatio(
//                     aspectRatio: _controller.value.aspectRatio,
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(6),
//                       child: VideoPlayer(_controller),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: _togglePlayPause,
//                     child: AnimatedOpacity(
//                       opacity: _controller.value.isPlaying ? 0.0 : 1.0,
//                       duration: const Duration(milliseconds: 300),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.black.withOpacity(0.5),
//                           shape: BoxShape.circle,
//                         ),
//                         padding: const EdgeInsets.all(12),
//                         child: const Icon(
//                           Icons.play_arrow,
//                           size: 48,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             } else if (snapshot.hasError) {
//               return Center(
//                 child: Text(
//                   'Error loading video: ${snapshot.error}',
//                   style: const TextStyle(color: Colors.red),
//                 ),
//               );
//             } else {
//               return const Center(child: CircularProgressIndicator());
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
//
//
///
// class VideoPlayerService extends StatefulWidget {
//   final String videoUrl;
//
//   const VideoPlayerService({super.key, required this.videoUrl});
//
//   @override
//   State<VideoPlayerService> createState() => _VideoPlayerServiceState();
// }
//
// class _VideoPlayerServiceState extends State<VideoPlayerService> {
//   late final VideoPlayerController _controller;
//   late final Future<void> _initializeVideoPlayerFuture;
//   bool _isVideoPlaying = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeController();
//   }
//
//   void _initializeController() {
//     _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
//     _initializeVideoPlayerFuture = _controller.initialize().then((_) {
//       if (mounted) setState(() {});
//     }).catchError((e) {
//       debugPrint('Video init error: $e');
//       if (mounted) setState(() {});
//     });
//
//     _controller.addListener(() {
//       if (!mounted) return;
//       final playing = _controller.value.isPlaying;
//       if (_isVideoPlaying != playing) {
//         setState(() => _isVideoPlaying = playing);
//       }
//     });
//   }
//
//   void _togglePlayPause() {
//     if (_controller.value.isInitialized) {
//       _controller.value.isPlaying ? _controller.pause() : _controller.play();
//     }
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   Widget _buildPlayerUI(BuildContext context) {
//     final screen = MediaQuery.of(context).size;
//     final isLandscape = screen.width > screen.height;
//     final width = screen.width * 0.7;
//     final height = isLandscape ? screen.height * 0.7 : screen.height * 0.2;
//
//     return Container(
//       width: width,
//       height: height,
//       padding: const EdgeInsets.all(12),
//       decoration: ShapeDecoration(
//         color: const Color(0xFF011116),
//         shape: RoundedRectangleBorder(
//           side: const BorderSide(width: 1, color: Color(0xFF7074A6)),
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           AspectRatio(
//             aspectRatio: _controller.value.aspectRatio,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(6),
//               child: VideoPlayer(_controller),
//             ),
//           ),
//           GestureDetector(
//             onTap: _togglePlayPause,
//             child: AnimatedOpacity(
//               opacity: _isVideoPlaying ? 0.0 : 1.0,
//               duration: const Duration(milliseconds: 300),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.5),
//                   shape: BoxShape.circle,
//                 ),
//                 padding: const EdgeInsets.all(12),
//                 child: const Icon(Icons.play_arrow, size: 48, color: Colors.white),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: FutureBuilder<void>(
//         future: _initializeVideoPlayerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done &&
//               _controller.value.isInitialized) {
//             return _buildPlayerUI(context);
//           } else if (snapshot.hasError) {
//             return Text(
//               'Error loading video: ${snapshot.error}',
//               style: const TextStyle(color: Colors.red),
//               textAlign: TextAlign.center,
//             );
//           } else {
//             return const CircularProgressIndicator();
//           }
//         },
//       ),
//     );
//   }
// }

///

//
// class VideoPlayerService extends StatefulWidget {
//   final String videoUrl;
//
//   const VideoPlayerService({super.key, required this.videoUrl});
//
//   @override
//   State<VideoPlayerService> createState() => _VideoPlayerServiceState();
// }
//
// class _VideoPlayerServiceState extends State<VideoPlayerService> {
//   VideoPlayerController? _videoController;
//   late Future<void> _initializeVideoPlayerFuture;
//   bool _isVideoPlaying = false;
//
//   YoutubePlayerController? _youtubeController;
//
//   bool get _isYouTube => YoutubePlayer.convertUrlToId(widget.videoUrl) != null;
//
//   @override
//   void initState() {
//     super.initState();
//     if (_isYouTube) {
//       _initializeYouTubePlayer();
//     } else {
//       _initializeVideoPlayer();
//     }
//   }
//
//   void _initializeYouTubePlayer() {
//     final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl)!;
//     _youtubeController = YoutubePlayerController(
//       initialVideoId: videoId,
//       flags: const YoutubePlayerFlags(
//         autoPlay: false,
//         mute: false,
//       ),
//     );
//   }
//
//   void _initializeVideoPlayer() {
//     _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
//     _initializeVideoPlayerFuture = _videoController!.initialize().then((_) {
//       if (mounted) setState(() {});
//     }).catchError((e) {
//       debugPrint('Video init error: $e');
//       if (mounted) setState(() {});
//     });
//
//     _videoController!.addListener(() {
//       if (!mounted) return;
//       final playing = _videoController!.value.isPlaying;
//       if (_isVideoPlaying != playing) {
//         setState(() => _isVideoPlaying = playing);
//       }
//     });
//   }
//
//   void _togglePlayPause() {
//     if (_videoController != null && _videoController!.value.isInitialized) {
//       _videoController!.value.isPlaying
//           ? _videoController!.pause()
//           : _videoController!.play();
//     }
//   }
//
//   @override
//   void dispose() {
//     _videoController?.dispose();
//     _youtubeController?.dispose();
//     super.dispose();
//   }
//
//   Widget _buildYouTubePlayer() {
//     final screen = MediaQuery.of(context).size;
//     final isLandscape = screen.width > screen.height;
//     final width = screen.width * 0.7;
//     final height = isLandscape ? screen.height * 0.7 : screen.height * 0.25;
//
//     return Container(
//       width: width,
//       height: height,
//       padding: const EdgeInsets.all(12),
//       decoration: ShapeDecoration(
//         color: const Color(0xFF011116),
//         shape: RoundedRectangleBorder(
//           side: const BorderSide(width: 1, color: Color(0xFF7074A6)),
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(6),
//         child: YoutubePlayer(
//           controller: _youtubeController!,
//           showVideoProgressIndicator: true,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildVideoPlayer() {
//     final screen = MediaQuery.of(context).size;
//     final isLandscape = screen.width > screen.height;
//     final width = screen.width * 0.7;
//     final height = isLandscape ? screen.height * 0.7 : screen.height * 0.2;
//
//     return Container(
//       width: width,
//       height: height,
//       padding: const EdgeInsets.all(12),
//       decoration: ShapeDecoration(
//         color: const Color(0xFF011116),
//         shape: RoundedRectangleBorder(
//           side: const BorderSide(width: 1, color: Color(0xFF7074A6)),
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           AspectRatio(
//             aspectRatio: _videoController!.value.aspectRatio,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(6),
//               child: VideoPlayer(_videoController!),
//             ),
//           ),
//           GestureDetector(
//             onTap: _togglePlayPause,
//             child: AnimatedOpacity(
//               opacity: _isVideoPlaying ? 0.0 : 1.0,
//               duration: const Duration(milliseconds: 300),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.5),
//                   shape: BoxShape.circle,
//                 ),
//                 padding: const EdgeInsets.all(12),
//                 child: const Icon(Icons.play_arrow, size: 48, color: Colors.white),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_isYouTube && _youtubeController != null) {
//       return _buildYouTubePlayer();
//     } else if (_videoController != null) {
//       return Center(
//         child: FutureBuilder<void>(
//           future: _initializeVideoPlayerFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.done &&
//                 _videoController!.value.isInitialized) {
//               return _buildVideoPlayer();
//             } else if (snapshot.hasError) {
//               return Text(
//                 'Error loading video: ${snapshot.error}',
//                 style: const TextStyle(color: Colors.red),
//                 textAlign: TextAlign.center,
//               );
//             } else {
//               return const CircularProgressIndicator();
//             }
//           },
//         ),
//       );
//     } else {
//       return const CircularProgressIndicator();
//     }
//   }
// }

///

class VideoPlayerService extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerService({super.key, required this.videoUrl});

  @override
  State<VideoPlayerService> createState() => _VideoPlayerServiceState();
}

class _VideoPlayerServiceState extends State<VideoPlayerService> {
  VideoPlayerController? _videoController;
  YoutubePlayerController? _youtubeController;

  bool get _isYouTube => YoutubePlayer.convertUrlToId(widget.videoUrl) != null;

  late Future<void> _initializeVideoFuture;

  @override
  void initState() {
    super.initState();
    if (_isYouTube) {
      final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl)!;
      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
    } else {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      _initializeVideoFuture = _videoController!.initialize();
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final width = screen.width * 0.8;
    final height = screen.height * 0.25;

    return Center(
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF011116),
          border: Border.all(color: const Color(0xFF7074A6)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: _isYouTube
            ? ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: YoutubePlayer(
            controller: _youtubeController!,
            showVideoProgressIndicator: true,
          ),
        )
            : FutureBuilder(
          future: _initializeVideoFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: VideoPlayer(_videoController!),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _videoController!.value.isPlaying
                            ? _videoController!.pause()
                            : _videoController!.play();
                      });
                    },
                    child: AnimatedOpacity(
                      opacity: _videoController!.value.isPlaying ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(12),
                        child: const Icon(Icons.play_arrow,
                            size: 48, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return const Text(
                'Error loading video',
                style: TextStyle(color: Colors.red),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}