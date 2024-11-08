import 'package:flutter/material.dart';
import '../ulits/balloon_utils.dart';
import '../config/animation_constants.dart';

class SequentialBalloons extends StatefulWidget {
  const SequentialBalloons({Key? key}) : super(key: key);

  @override
  State<SequentialBalloons> createState() => _SequentialBalloonsState();
}

class _SequentialBalloonsState extends State<SequentialBalloons>
    with TickerProviderStateMixin {
  late List<AnimationController> _floatControllers;
  late List<AnimationController> _scaleControllers;
  late List<Animation<double>> _floatAnimations;
  late List<Animation<double>> _scaleAnimations;

  final int balloonCount = 4;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startSequence();
  }

  void _initializeAnimations() {
    _floatControllers = List.generate(balloonCount, (index) {
      return AnimationController(
        duration: AnimationConstants.slowDuration,
        vsync: this,
      );
    });

    _scaleControllers = List.generate(balloonCount, (index) {
      return AnimationController(
        duration: AnimationConstants.defaultDuration,
        vsync: this,
      );
    });

    _floatAnimations = _floatControllers.map((controller) {
      return Tween<double>(begin: 0, end: 1).animate(controller);
    }).toList();

    _scaleAnimations = _scaleControllers.map((controller) {
      return Tween<double>(begin: 1, end: 0).animate(controller);
    }).toList();
  }

  void _startSequence() {
    for (int i = 0; i < balloonCount; i++) {
      Future.delayed(Duration(milliseconds: i * 500), () {
        _floatControllers[i].forward().then((_) {
          _scaleControllers[i].forward();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(balloonCount, (index) {
        return AnimatedBuilder(
          animation: Listenable.merge([_floatAnimations[index], _scaleAnimations[index]]),
          builder: (context, child) {
            return Positioned(
              left: 50.0 + (index * 70), // Staggered positions horizontally
              bottom: _floatAnimations[index].value * MediaQuery.of(context).size.height,
              child: Transform.scale(
                scale: _scaleAnimations[index].value,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BalloonUtils.buildBalloon(
                      color: const Color.fromARGB(255, 215, 14, 24).withOpacity(0.7 + (0.3 * index / balloonCount)), // Different shades of yellow
                      scale: AnimationConstants.defaultBalloonScale,
                    ),
                    Container(
                      width: 2,
                      height: 50,
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
    for (final controller in _floatControllers) {
      controller.dispose();
    }
    for (final controller in _scaleControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}