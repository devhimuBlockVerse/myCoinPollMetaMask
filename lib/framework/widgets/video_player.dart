import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class VideoPlayerService extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerService({super.key, required this.videoUrl});

  @override
  State<VideoPlayerService> createState() => _VideoPlayerServiceState();
}

class _VideoPlayerServiceState extends State<VideoPlayerService> {
  YoutubePlayerController? _youtubeController;
  bool _isFullscreen = false;

  bool get _isYouTube => YoutubePlayer.convertUrlToId(widget.videoUrl) != null;

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
          forceHD: true,
          enableCaption: false,
        ),
      )..addListener(_listener);
    }
  }

  void _listener() {
    if (_youtubeController == null) return;

    final isFull = _youtubeController!.value.isFullScreen;

    if (_isFullscreen != isFull) {
      _isFullscreen = isFull;

      if (_isFullscreen) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);

        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      }
    }
  }

  @override
  void dispose() {
    _youtubeController?.removeListener(_listener);
    _youtubeController?.dispose();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isYouTube) return const SizedBox();

    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _youtubeController!,
        showVideoProgressIndicator: true,
        progressColors: const ProgressBarColors(
          playedColor: Colors.red,
          handleColor: Colors.redAccent,
        ),
      ),
      builder: (context, player) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF011116),
            border: Border.all(color: const Color(0xFF7074A6)),
            borderRadius: BorderRadius.circular(5),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: player,
          ),
        );
      },
    );
  }
}
