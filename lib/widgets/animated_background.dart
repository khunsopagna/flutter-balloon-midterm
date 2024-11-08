import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({Key? key}) : super(key: key);

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(_controller);

    _controller.repeat();
  }

@override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Sunset gradient background
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFC371), // Light Orange
                Color(0xFFFF5F6D), // Pinkish Orange
                Color(0xFF6A0572), // Deep Purple
              ],
            ),
          ),
        ),
        
        // Cloud 1
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Positioned(
              left: MediaQuery.of(context).size.width * _animation.value,
              top: 100,
              child: _buildCloud(size: 100, opacity: 0.8),
            );
          },
        ),

        // Cloud 2
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Positioned(
              left: MediaQuery.of(context).size.width * (_animation.value + 0.5) % MediaQuery.of(context).size.width,
              top: 180,
              child: _buildCloud(size: 80, opacity: 0.7),
            );
          },
        ),

        // Cloud 3
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Positioned(
              left: MediaQuery.of(context).size.width * (_animation.value - 0.3) % MediaQuery.of(context).size.width,
              top: 250,
              child: _buildCloud(size: 120, opacity: 0.85),
            );
          },
        ),
        
        // Bird 1
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Positioned(
              left: MediaQuery.of(context).size.width * (_animation.value - 0.1) % MediaQuery.of(context).size.width,
              top: 150,
              child: _buildBird(),
            );
          },
        ),

        // Bird 2
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Positioned(
              left: MediaQuery.of(context).size.width * (_animation.value + 0.3) % MediaQuery.of(context).size.width,
              top: 200,
              child: _buildBird(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCloud({double size = 100, double opacity = 0.8}) {
    return Container(
      width: size,
      height: size * 0.6,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(opacity),
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
    );
  }

  Widget _buildBird() {
    return CustomPaint(
      size: const Size(30, 20),
      painter: BirdPainter(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class BirdPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw left wing
    final leftWingPath = Path();
    leftWingPath.moveTo(size.width * 0.5, size.height * 0.5);
    leftWingPath.quadraticBezierTo(
      size.width * 0.2, size.height * 0.1, 
      size.width * 0.0, size.height * 0.5,
    );
    canvas.drawPath(leftWingPath, paint);

    // Draw right wing
    final rightWingPath = Path();
    rightWingPath.moveTo(size.width * 0.5, size.height * 0.5);
    rightWingPath.quadraticBezierTo(
      size.width * 0.8, size.height * 0.1, 
      size.width * 1.0, size.height * 0.5,
    );
    canvas.drawPath(rightWingPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
