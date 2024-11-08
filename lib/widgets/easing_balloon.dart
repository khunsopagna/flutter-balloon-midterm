import 'package:flutter/material.dart';
import '../ulits/balloon_utils.dart';
import '../config/animation_constants.dart';

class EasingBalloon extends StatefulWidget {
  const EasingBalloon({Key? key}) : super(key: key);

  @override
  State<EasingBalloon> createState() => _EasingBalloonState();
}

class _EasingBalloonState extends State<EasingBalloon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AnimationConstants.defaultDuration,
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutBack,
      ),
    );

    _controller.repeat(reverse: true);
  }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _animation,
//       builder: (context, child) {
//         return Positioned(
//           left: MediaQuery.of(context).size.width / 2 -
//               AnimationConstants.defaultBalloonSize / 2,
//           bottom: _animation.value * MediaQuery.of(context).size.height,
//           child: BalloonUtils.buildBalloon(
//             color: const Color.fromARGB(232, 235, 228, 29),
//             scale: AnimationConstants.defaultBalloonScale,
//           ),
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }

@override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        double balloonPosition = _animation.value * MediaQuery.of(context).size.height;
        return Stack(
          children: [
            Positioned(
              left: MediaQuery.of(context).size.width / 2 -
                  AnimationConstants.defaultBalloonSize / 2,
              bottom: balloonPosition,
              child: Column(
                children: [
                  // Balloon itself
                  BalloonUtils.buildBalloon(
                    color: const Color.fromARGB(232, 235, 228, 29),
                    scale: AnimationConstants.defaultBalloonScale,
                  ),
                  // Balloon string
                  Container(
                    width: 2,
                    height: 50,
                    color: Colors.black, // You can adjust the color and length as needed
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}