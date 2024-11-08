import 'package:flutter/material.dart';
import '../ulits/balloon_utils.dart';
import '../config/animation_constants.dart';
import 'package:audioplayers/audioplayers.dart';

class SoundController extends StatefulWidget {
  const SoundController({Key? key}) : super(key: key);

  @override
  State createState() => _SoundControllerState();
}

class _SoundControllerState extends State<SoundController> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _playBackgroundSound();
  }

  // Play background sound from assets
  void _playBackgroundSound() async {
    await _audioPlayer.play(AssetSource('assets/sounds/wind.wav')); // Ensure asset path is correct
    await _audioPlayer.setReleaseMode(ReleaseMode.loop); // Loop the sound
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Clean up the audio player to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBalloon(
        color: const Color.fromARGB(255, 66, 229, 221), // Balloon color
        initialScale: 1.0, // Balloon scale for size
      ),
    );
  }
}

class AnimatedBalloon extends StatefulWidget {
  final Color color;
  final double initialScale;

  const AnimatedBalloon({
    Key? key,
    required this.color,
    this.initialScale = AnimationConstants.defaultBalloonScale,
  }) : super(key: key);

  @override
  State createState() => _AnimatedBalloonState();
}

class _AnimatedBalloonState extends State<AnimatedBalloon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _scaleAnimation;
  late Animation _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AnimationConstants.defaultDuration,
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween(
      begin: AnimationConstants.minPulseScale,
      end: AnimationConstants.maxPulseScale,
    ).animate(_controller);

    _rotationAnimation = Tween(
      begin: AnimationConstants.minRotation,
      end: AnimationConstants.maxRotation,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center, // Center the balloon and string together
          children: [
            // Balloon with attached string
            Transform.rotate(
              angle: _rotationAnimation.value,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Balloon
                  Transform.scale(
                    scale: _scaleAnimation.value * widget.initialScale,
                    child: BalloonUtils.buildBalloon(
                      color: widget.color,
                      scale: widget.initialScale,
                    ),
                  ),
                  // Balloon String
                  Transform.scale(
                    scale: _scaleAnimation.value, // Scale string with the balloon
                    child: Container(
                      width: 2, // String width
                      height: 50, // String length
                      color: Colors.brown, // String color
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}