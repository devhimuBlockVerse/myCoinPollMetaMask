 import 'package:audio_service/audio_service.dart';
import 'package:video_player/video_player.dart';

// Future<MyAudioHandler> initAudioService(String videoUrl, String videoTitle) async {
//
//   return await AudioService.init<MyAudioHandler>(
//     builder: () => MyAudioHandler(videoUrl,videoTitle),
//     config: AudioServiceConfig(
//       androidNotificationChannelId: 'com.yourcompany.audio',
//       androidNotificationChannelName: 'Audio playback',
//       androidNotificationOngoing: true,
//       androidShowNotificationBadge: true,
//       androidStopForegroundOnPause: false,
//     ),
//   );
// }
//
// class MyAudioHandler extends BaseAudioHandler with SeekHandler {
//   VideoPlayerController? _videoController;
//   final String _initialVideoUrl;
//   final String _initialVideoTitle;
//   MediaItem? _mediaItem;
//
//   // To expose the controller to the UI for video rendering
//   VideoPlayerController? get videoController => _videoController;
//
//   MyAudioHandler(this._initialVideoUrl, this._initialVideoTitle) {
//     _mediaItem = MediaItem(
//       id: _initialVideoUrl,
//       title: _initialVideoTitle,
//       // artist: "Your App Name", // Optional
//      );
//     mediaItem.add(_mediaItem);
//     _initVideoPlayer(_initialVideoUrl);
//   }
//
//
//   Future<void> _initVideoPlayer(String url) async {
//     await _videoController?.dispose();
//
//     _videoController = VideoPlayerController.networkUrl(Uri.parse(url));
//     try {
//       await _videoController!.initialize();
//       await _videoController!.play(); // Auto-play
//       customEvent.add('initialized');
//
//       // Update mediaItem with new duration
//       _mediaItem = _mediaItem?.copyWith(duration: _videoController!.value.duration);
//       mediaItem.add(_mediaItem!);
//
//       _videoController!.addListener(() {
//         if (_videoController == null || !_videoController!.value.isInitialized) return;
//
//         final isPlaying = _videoController!.value.isPlaying;
//         final position = _videoController!.value.position;
//         final buffered = _videoController!.value.buffered.isNotEmpty
//             ? _videoController!.value.buffered.last.end
//             : Duration.zero;
//
//         playbackState.add(playbackState.value.copyWith(
//           controls: [
//             isPlaying ? MediaControl.pause : MediaControl.play,
//             MediaControl.stop,
//           ],
//           systemActions: const {
//             MediaAction.seek,
//             MediaAction.seekForward,
//             MediaAction.seekBackward,
//           },
//           processingState: _getProcessingState(),
//           playing: isPlaying,
//           updatePosition: position,
//           bufferedPosition: buffered,
//           speed: _videoController!.value.playbackSpeed,
//         ));
//       });
//
//     } catch (e) {
//       print("Error initializing video player in AudioHandler: $e");
//       playbackState.add(playbackState.value.copyWith(
//         processingState: AudioProcessingState.error,
//         errorMessage: e.toString(),
//       ));
//     }
//   }
//
//   AudioProcessingState _getProcessingState() {
//     if (_videoController == null) return AudioProcessingState.idle;
//     if (!_videoController!.value.isInitialized) return AudioProcessingState.loading;
//     if (_videoController!.value.hasError) return AudioProcessingState.error;
//     if (_videoController!.value.isBuffering) return AudioProcessingState.buffering;
//     return AudioProcessingState.ready;
//   }
//
//
//   @override
//   Future<void> play() async {
//     if (_videoController != null && _videoController!.value.isInitialized) {
//       await _videoController!.play();
//       playbackState.add(playbackState.value.copyWith(playing: true));
//     }
//   }
//
//   @override
//   Future<void> pause() async {
//     if (_videoController != null && _videoController!.value.isInitialized) {
//       await _videoController!.pause();
//       playbackState.add(playbackState.value.copyWith(playing: false));
//     }
//   }
//
//   @override
//   Future<void> seek(Duration position) async {
//     if (_videoController != null && _videoController!.value.isInitialized) {
//       await _videoController!.seekTo(position);
//       playbackState.add(playbackState.value.copyWith(updatePosition: position));
//     }
//   }
//
//   @override
//   Future<void> stop() async {
//     if (_videoController != null) {
//       await _videoController!.pause(); // or dispose if you want to release it fully
//       await _videoController!.seekTo(Duration.zero);
//       playbackState.add(playbackState.value.copyWith(
//         playing: false,
//         processingState: AudioProcessingState.ready, // Or ready if you allow restart
//       ));
//     }
//     return super.stop(); // This will stop the service if configured
//   }
//
//   @override
//   Future<void> customAction(String name, [Map<String, dynamic>? extras]) async {
//     if (name == 'dispose') {
//       await _videoController?.dispose();
//       _videoController = null;
//       await super.stop(); // Properly stop the service
//     }
//     if (name == 'load_new_url') {
//       final newUrl = extras?['url'] as String?;
//       final newTitle = extras?['title'] as String? ?? "New Video";
//       if (newUrl != null) {
//         _mediaItem = MediaItem(id: newUrl, title: newTitle);
//         mediaItem.add(_mediaItem);
//         await _initVideoPlayer(newUrl);
//       }
//     }
//   }
//
// }