import 'package:flutter/material.dart';
import 'package:serenti/app/view/theme/serenti_colors.dart';

class HabitatBackground extends StatelessWidget {
  const HabitatBackground({
    super.key,
    this.activityLevel = 0.0,
    this.isHighRisk = false,
  });

  /// Activity level from 0.0 to 1.0 to affect decorations.
  final double activityLevel;

  /// Whether the system is in a high-risk state.
  final bool isHighRisk;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final hour = now.hour;

    List<Color> gradient;
    if (isHighRisk) {
      gradient = SerentiColors.alertGradient;
    } else if (hour >= 6 && hour < 12) {
      gradient = SerentiColors.morningGradient;
    } else if (hour >= 12 && hour < 18) {
      gradient = SerentiColors.afternoonGradient;
    } else if (hour >= 18 && hour < 22) {
      gradient = SerentiColors.eveningGradient;
    } else {
      gradient = [SerentiColors.nightGradientStart, SerentiColors.nightGradientEnd];
    }

    return Stack(
      children: [
        // Background Gradient
        AnimatedContainer(
          duration: const Duration(seconds: 2),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: gradient,
            ),
          ),
        ),
        // Organic Decorations (Particles/Bubbles)
        Positioned.fill(
          child: CustomPaint(
            painter: _OrganicDecoratorPainter(
              activityLevel: activityLevel,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
        ),
      ],
    );
  }
}

class _OrganicDecoratorPainter extends CustomPainter {
  _OrganicDecoratorPainter({required this.activityLevel, required this.color});

  final double activityLevel;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;

    // Draw some soft circles/blobs
    final center1 = Offset(size.width * 0.2, size.height * 0.3);
    final radius1 = size.width * (0.3 + (activityLevel * 0.1));
    canvas.drawCircle(center1, radius1, paint);

    final center2 = Offset(size.width * 0.8, size.height * 0.7);
    final radius2 = size.width * (0.4 + (activityLevel * 0.1));
    canvas.drawCircle(center2, radius2, paint);
  }

  @override
  bool shouldRepaint(_OrganicDecoratorPainter oldDelegate) {
    return oldDelegate.activityLevel != activityLevel;
  }
}
