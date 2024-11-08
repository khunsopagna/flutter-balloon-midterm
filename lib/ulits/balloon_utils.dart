import 'package:flutter/material.dart';

class BalloonUtils {
  static Widget buildBalloon({
    required Color color,
    double scale = 1.0,
    bool withString = true,
  }) {
    return Container(
      width: 100 * scale,
      height: 120 * scale,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [color.withOpacity(0.8), color],
          center: const Alignment(0.3, -0.5),
        ),
        borderRadius: BorderRadius.circular(50 * scale),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10 * scale,
            offset: Offset(5 * scale, 5 * scale),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Balloon highlight
          Positioned(
            top: 10 * scale,
            left: 20 * scale,
            child: Container(
              width: 30 * scale,
              height: 20 * scale,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10 * scale),
              ),
            ),
          ),
          if (withString)
            Positioned(
              bottom: -30 * scale,
              left: 50 * scale,
              child: Container(
                width: 2 * scale,
                height: 30 * scale,
                color: Colors.grey,
              ),
            ),
        ],
      ),
    );
  }
}
