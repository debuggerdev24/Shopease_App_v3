import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';

// Video Player Provider
class VideoPlayerProvider extends ChangeNotifier {
  VideoPlayerController? _controller;
  bool _isPlaying = false;
  bool _showControls = true;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool _isFullScreen = false;
  bool _isMute = false;
  bool _isInitialized = false;
  bool _isLoading = true;

  // Getters
  VideoPlayerController? get controller => _controller;
  bool get isPlaying => _isPlaying;
  bool get showControls => _showControls;
  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => _totalDuration;
  bool get isFullScreen => _isFullScreen;
  bool get isMute => _isMute;
  bool get isInitialized => _isInitialized;
  bool get isLoading => _isLoading;

  void initializeVideoPlayer(String videoUrl) {
    _isLoading = true;
    notifyListeners();

    _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
      ..initialize().then((_) {
        _totalDuration = _controller!.value.duration;
        _isInitialized = true;
        _isLoading = false;
        notifyListeners();
      }).catchError((error) {
        _isLoading = false;
        notifyListeners();
      });

    _controller!.addListener(_videoListener);
  }

  void _videoListener() {
    _currentPosition = _controller!.value.position;
    _isPlaying = _controller!.value.isPlaying;
    notifyListeners();
  }

  void togglePlayPause() {
    if (_controller != null && _isInitialized) {
      if (_isPlaying) {
        _controller!.pause();
      } else {
        _controller!.play();
      }
    }
  }

  void toggleControls() {
    _showControls = !_showControls;
    notifyListeners();
  }

  void seekTo(Duration position) {
    if (_controller != null && _isInitialized) {
      _controller!.seekTo(position);
    }
  }

  void toggleFullScreen() {
    _isFullScreen = !_isFullScreen;
    notifyListeners();
  }

  void toggleMute() {
    if (_controller != null && _isInitialized) {
      if (_isMute) {
        _controller!.setVolume(1);
      } else {
        _controller!.setVolume(0);
      }
      _isMute = !_isMute;
      notifyListeners();
    }
  }

  void showControlsTemporarily() {
    _showControls = true;
    notifyListeners();

    // Hide controls after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      _showControls = false;
      notifyListeners();
    });
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    super.dispose();
  }
}

// Custom Video Player Widget
class CustomVideoPlayer extends StatelessWidget {
  final String videoUrl;
  final double aspectRatio;

  const CustomVideoPlayer({
    Key? key,
    required this.videoUrl,
    this.aspectRatio = 16 / 9,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          VideoPlayerProvider()..initializeVideoPlayer(videoUrl),
      child: Consumer<VideoPlayerProvider>(
        builder: (context, provider, child) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: aspectRatio,
                child: GestureDetector(
                  onTap: () => provider.toggleControls(),
                  child: Stack(
                    children: [
                      // Video Content
                      _buildVideoContent(provider),

                      // Video Content Overlay (when not initialized)
                      if (!provider.isInitialized) _buildContentOverlay(),

                      // Controls Overlay
                      if (provider.showControls)
                        _buildControlsOverlay(context, provider),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideoContent(VideoPlayerProvider provider) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFF8B7EC8),
      child: provider.isInitialized && provider.controller != null
          ? VideoPlayer(provider.controller!)
          : provider.isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : const SizedBox(),
    );
  }

  Widget _buildContentOverlay() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFF8B7EC8),
      child: Row(
        children: [
          // Left side - App mockup
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'Shopease',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
          ),

          // Center - Phone mockup
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Phone header
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Checkout',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text('9:41'),
                          ),
                        ],
                      ),
                    ),
                    // Phone content
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // Product items
                            for (int i = 0; i < 3; i++)
                              Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Product Name',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          Text(
                                            '\$29.99',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            const Spacer(),
                            // Checkout button
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Text(
                                  'Checkout',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Right side - Character
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Character illustration placeholder
                  Container(
                    width: 80,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.green[400],
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlsOverlay(
      BuildContext context, VideoPlayerProvider provider) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.7),
            Colors.transparent,
            Colors.transparent,
            Colors.black.withOpacity(0.7),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox.shrink(),

          // Center play button
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => provider.togglePlayPause(),
              icon: Icon(
                provider.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),

          // Bottom controls
          if (provider.isInitialized)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // completed time
                  // Text(
                  //   provider.formatDuration(provider.currentPosition),
                  //   style: const TextStyle(
                  //     color: Colors.white,
                  //     fontSize: 12,
                  //   ),
                  // ),

                  // Play pause button
                  IconButton(
                    onPressed: () => provider.togglePlayPause(),
                    icon: Icon(
                      provider.isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      value: provider.totalDuration.inMilliseconds > 0
                          ? provider.currentPosition.inMilliseconds.toDouble()
                          : 0.0,
                      max: provider.totalDuration.inMilliseconds.toDouble(),
                      onChanged: (value) {
                        provider.seekTo(Duration(milliseconds: value.toInt()));
                      },
                      activeColor: Colors.white,
                      inactiveColor: Colors.white.withOpacity(0.3),
                    ),
                  ),

                  // volume button
                  IconButton(
                    onPressed: () => provider.toggleMute(),
                    icon: Icon(
                      provider.isMute ? Icons.volume_off : Icons.volume_up,
                      color: Colors.white,
                    ),
                  ),

                  // full screen button
                  IconButton(
                    onPressed: () => provider.toggleFullScreen(),
                    icon: Icon(
                      provider.isFullScreen
                          ? Icons.fullscreen_exit
                          : Icons.fullscreen,
                      color: Colors.white,
                    ),
                  ),

                  // total duration
                  // Text(
                  //   provider.formatDuration(provider.totalDuration),
                  //   style: const TextStyle(
                  //     color: Colors.white,
                  //     fontSize: 12,
                  //   ),
                  // ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
