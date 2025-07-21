import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


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