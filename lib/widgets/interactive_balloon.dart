import 'package:flutter/material.dart';
import '../ulits/balloon_utils.dart';
import '../config/animation_constants.dart';

class InteractiveBalloon extends StatefulWidget {
  const InteractiveBalloon({Key? key}) : super(key: key);

  @override
  State<InteractiveBalloon> createState() => _InteractiveBalloonState();
}

class _InteractiveBalloonState extends State<InteractiveBalloon>
    with SingleTickerProviderStateMixin {
  Offset _position = const Offset(100, 100);
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      duration: AnimationConstants.defaultDuration,
      vsync: this,
    )..repeat(reverse: true);

    // Setup scale animation
    _scaleAnimation = Tween<double>(
      begin: AnimationConstants.minPulseScale,
      end: AnimationConstants.maxPulseScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Setup rotation animation
    _rotationAnimation = Tween<double>(
      begin: AnimationConstants.minRotation,
      end: AnimationConstants.maxRotation,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Offset _constrainPosition(Offset position) {
    final screenSize = MediaQuery.of(context).size;
    final balloonSize = AnimationConstants.defaultBalloonSize;

    return Offset(
      position.dx.clamp(0, screenSize.width - balloonSize),
      position.dy.clamp(0, screenSize.height - balloonSize),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _position = _constrainPosition(_position + details.delta);
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Balloon widget
                    BalloonUtils.buildBalloon(
                      color: const Color.fromARGB(255, 249, 33, 245),
                      scale: AnimationConstants.defaultBalloonScale,
                    ),
                    // Balloon string
                    Container(
                      width: 2,
                      height: 50, // Adjust height as needed for the string length
                      color: Colors.brown, // Color for the string
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}