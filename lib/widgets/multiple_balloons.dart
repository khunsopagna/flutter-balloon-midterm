// widgets/multiple_balloons.dart
import 'package:flutter/material.dart';
import 'dart:math';
import '../ulits/balloon_utils.dart';
import '../config/animation_constants.dart';

class MultipleBalloons extends StatefulWidget {
  const MultipleBalloons({Key? key}) : super(key: key);

  @override
  State<MultipleBalloons> createState() => _MultipleBalloonsState();
}

class _MultipleBalloonsState extends State<MultipleBalloons>
    with TickerProviderStateMixin {
  final List<AnimationController> _controllers = [];
  final List<Animation<double>> _animations = [];
  final List<Offset> _positions = [];
  final int numberOfBalloons = 5;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    for (int i = 0; i < numberOfBalloons; i++) {
      // Create controllers with different durations
      final controller = AnimationController(
        duration: Duration(seconds: 2 + i),
        vsync: this,
      );

      // Create animations with different curves
      final animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOut,
        ),
      );

      // Generate random initial positions
      final position = Offset(
        _random.nextDouble() * 300,
        _random.nextDouble() * 400,
      );

      _controllers.add(controller);
      _animations.add(animation);
      _positions.add(position);

      // Start the animation with a slight delay
      Future.delayed(Duration(milliseconds: 500 * i), () {
        controller.repeat(reverse: true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(numberOfBalloons, (index) {
        return AnimatedBuilder(
          animation: _controllers[index],
          builder: (context, child) {
            // Balloon position and animation logic
            final balloonPosition = _positions[index];
            final floatPosition = balloonPosition.dy + (sin(_controllers[index].value * pi) * 50);

            return Positioned(
              left: balloonPosition.dx,
              top: floatPosition,
              child: Transform.scale(
                scale: _animations[index].value,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Balloon
                    BalloonUtils.buildBalloon(
                      color: Colors.primaries[index % Colors.primaries.length],
                      scale: AnimationConstants.smallBalloonScale,
                    ),
                    // Balloon String
                    Container(
                      width: 2,
                      height: 50, // Adjust string height as needed
                      color: Colors.brown,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}