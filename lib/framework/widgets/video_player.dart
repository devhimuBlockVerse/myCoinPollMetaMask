import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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


import 'package:audio_service/audio_service.dart';

import '../../application/data/services/my_audio_handler.dart'; // Update with your app name


class VideoPlayerService extends StatefulWidget {
  final String videoUrl;
  final String videoTitle;

  const VideoPlayerService({
    super.key,
    required this.videoUrl,
    this.videoTitle = "Playing Video",
  });

  @override
  State<VideoPlayerService> createState() => _VideoPlayerServiceState();
}

class _VideoPlayerServiceState extends State<VideoPlayerService> {
  MyAudioHandler? _audioHandlerInstance;
  VideoPlayerController? _currentVideoController;
  // To manage subscriptions and cancel them in dispose
  StreamSubscription<PlaybackState>? _playbackStateSubscription;
  StreamSubscription<MediaItem?>? _mediaItemSubscription;


  @override
  void initState() {
    super.initState();
    _connectToAudioServiceAndLoadMedia();
  }

  Future<void> _connectToAudioServiceAndLoadMedia() async {
    // Obtain the handler instance. This will initialize the service if not already running,
    // or return the existing handler.
    // The MyAudioHandler's constructor will be called only if it's the first time.
    // If it's already running, initAudioService should ideally be designed to either
    // return the existing instance or reconfigure it.
    // Our initAudioService function calls AudioService.init, which handles this.
    _audioHandlerInstance = await initAudioService(widget.videoUrl, widget.videoTitle);

    // Now that we have the handler, check if its current media item needs updating.
    // The MyAudioHandler's constructor already calls _initVideoPlayer with the initial URL.
    // If this widget instance is created with a *different* URL than what the handler
    // might currently be playing (e.g., if the handler was already running from a previous screen),
    // we need to tell it to load the new URL.
    if (_audioHandlerInstance?.mediaItem.value?.id != widget.videoUrl) {
      print("Requesting new URL: ${widget.videoUrl}");
      await _audioHandlerInstance?.customAction('load_new_url', {
        'url': widget.videoUrl,
        'title': widget.videoTitle,
      });
    } else {
      // If the URL is the same, ensure the controller is updated in the UI
      // This might be redundant if the handler's constructor already set it up
      // and the stream listeners below catch it.
      print("URL is the same or handler just initialized with it.");
      _updateControllerFromHandler();
    }

    // Cancel previous subscriptions if any
    await _playbackStateSubscription?.cancel();
    await _mediaItemSubscription?.cancel();

    // Listen to playback state changes from the handler
    _playbackStateSubscription = _audioHandlerInstance?.playbackState.listen((_) {
      // This listener primarily triggers UI rebuilds based on playback state (play/pause icon, etc.)
      // It can also be used to refresh controller if absolutely necessary, but
      // _mediaItemSubscription is better for controller changes due to new media.
      if (mounted) setState(() {});
      _updateControllerFromHandler(); // Ensure controller reference is fresh
    });

    // Listen to media item changes (e.g., when a new video is loaded by the handler)
    _mediaItemSubscription = _audioHandlerInstance?.mediaItem.listen((mediaItem) {
      print("MediaItem changed in UI: ${mediaItem?.title}");
      _updateControllerFromHandler(); // Update controller if media item change implies new source
    });


    if (mounted) {
      setState(() {}); // Initial UI update
    }
  }

  void _updateControllerFromHandler() {
    final newController = _audioHandlerInstance?.videoController;
    if (newController != _currentVideoController) {
      if (mounted) {
        setState(() {
          _currentVideoController = newController;
          print("UI VideoController updated.");
        });
      }
    } else if (newController != null && _currentVideoController == null) {
      // Case where controller was null and now it's available
      if (mounted) {
        setState(() {
          _currentVideoController = newController;
          print("UI VideoController initialized.");
        });
      }
    }
  }

  @override
  void dispose() {
    // Cancel stream subscriptions to prevent memory leaks
    _playbackStateSubscription?.cancel();
    _mediaItemSubscription?.cancel();
    // The UI disposing doesn't necessarily stop the audio.
    // The audio service lifecycle is separate.
    // If you want to explicitly stop and dispose the handler when this widget is disposed:
    // _audioHandlerInstance?.customAction('dispose');
    super.dispose();
  }

  void _togglePlayPause() {
    // Ensure we have the latest playback state before toggling
    final isPlaying = _audioHandlerInstance?.playbackState.value.playing ?? false;
    if (isPlaying) {
      _audioHandlerInstance?.pause();
    } else {
      _audioHandlerInstance?.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    // ... (rest of your build method is likely okay, but ensure it uses _currentVideoController
    // and listens to playbackState for UI changes like play/pause icon)

    final screenSize = MediaQuery.of(context).size;
    final isLandscape = screenSize.width > screenSize.height;
    final videoWidth = screenSize.width * 0.7;
    final videoHeight = isLandscape ? screenSize.height * 0.7 : screenSize.height * 0.2;

    // Use StreamBuilder for PlaybackState to react to play/pause, buffering, etc.
    return StreamBuilder<PlaybackState>(
      stream: _audioHandlerInstance?.playbackState ?? Stream.empty(),
      builder: (context, snapshot) {
        final playbackStateData = snapshot.data;
        final isPlaying = playbackStateData?.playing ?? false;
        final processingState = playbackStateData?.processingState ?? AudioProcessingState.idle;

        // Debug print
        // print("UI Build: Controller: ${_currentVideoController?.textureId}, Initialized: ${_currentVideoController?.value.isInitialized}, Playing: $isPlaying, Processing: $processingState");


        Widget playerWidget;
        if (_currentVideoController != null && _currentVideoController!.value.isInitialized) {
          playerWidget = Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: _currentVideoController!.value.aspectRatio > 0
                    ? _currentVideoController!.value.aspectRatio
                    : 16 / 9, // Default aspect ratio if not available
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: VideoPlayer(_currentVideoController!),
                ),
              ),
              GestureDetector(
                onTap: _togglePlayPause,
                child: AnimatedOpacity(
                  opacity: isPlaying ? 0.0 : 1.0, // Show button if not playing
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: const Icon(
                      Icons.play_arrow,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        } else if (processingState == AudioProcessingState.loading || processingState == AudioProcessingState.buffering) {
          playerWidget = const Center(child: CircularProgressIndicator());
        } else if (processingState == AudioProcessingState.error) {
          playerWidget = Center(
            child: Text(
              'Error: ${playbackStateData?.errorMessage ?? "Failed to load video"}',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          );
        } else {
          // Fallback or initial state before controller is ready
          playerWidget = const Center(child: Text("Waiting for video...", style: TextStyle(color: Colors.white)));
        }

        return Center(
          child: Container(
            width: videoWidth,
            height: videoHeight,
            padding: const EdgeInsets.all(12),
            decoration: ShapeDecoration(
              color: const Color(0xFF011116),
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: Color(0xFF7074A6)),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: playerWidget,
          ),
        );
      },
    );
  }
}