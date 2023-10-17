import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CircularChart extends StatelessWidget {
  final double current;
  final double goal;
  final Color color;

  const CircularChart({
    Key? key,
    required this.current,
    required this.color,
    required this.goal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double progressPercent = (current / goal).clamp(0.0, 1.0);
    String percentageText = ' ${(progressPercent * 100).toInt()} %';

    return Container(
      width: 200.0,
      height: 200.0,
      child: Stack(
        children: [
          Center(
            child: Text(
              percentageText,
              style: GoogleFonts.rubik(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 40,
              ),
            ),
          ),
          CustomPaint(
            size: const Size(400.0, 400.0),
            painter: ProgressPainter(progressPercent,color),
          ),
        ],
      ),
    );
  }
}

class ProgressPainter extends CustomPainter {
  final double progressPercent;
  final Color color;
  final double ringWidth = 17.0;

  ProgressPainter(this.progressPercent, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.width / 2;
    double centerX = size.width / 2;
    double centerY = size.height / 2;

    double startAngle = -90.0;
    double fullSweepAngle = 360.0;

    // Draw the remaining arc
    Rect remainingRect = Rect.fromCircle(center: Offset(centerX, centerY), radius: radius);
    final remainingPaint = Paint()
      ..color =  color.withOpacity(0.1)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = ringWidth;

    canvas.drawArc(remainingRect, radians(startAngle), radians(fullSweepAngle), false, remainingPaint);

    // Draw the progress arc
    double sweepAngle = 360.0 * progressPercent;
    Rect progressRect = Rect.fromCircle(center: Offset(centerX, centerY), radius: radius);
    final progressPaint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = ringWidth;

    canvas.drawArc(progressRect, radians(startAngle), radians(sweepAngle), false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}


double radians(double degrees) {
  return degrees * (3.141592653589793 / 180);
}
