import 'package:flutter/material.dart';

class CenterArea extends StatelessWidget {
  final double size;

  const CenterArea({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        size: Size(size, size),
        painter: CenterTrianglePainter(),
      ),
    );
  }
}

class CenterTrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    final center = Offset(size.width / 2, size.height / 2);
    
    // Green triangle (top)
    paint.color = const Color(0xFF00C853);
    final greenPath = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(center.dx, center.dy)
      ..close();
    canvas.drawPath(greenPath, paint);
    
    // Blue triangle (left) - Changed from Yellow
    paint.color = const Color(0xFF2196F3);
    final bluePath = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height)
      ..lineTo(center.dx, center.dy)
      ..close();
    canvas.drawPath(bluePath, paint);
    
    // Yellow triangle (right) - Changed from Blue
    paint.color = const Color(0xFFFFEB3B);
    final yellowPath = Path()
      ..moveTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(center.dx, center.dy)
      ..close();
    canvas.drawPath(yellowPath, paint);
    
    // Red triangle (bottom)
    paint.color = const Color(0xFFFF0000);
    final redPath = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(center.dx, center.dy)
      ..close();
    canvas.drawPath(redPath, paint);

    // Draw borders
    paint.style = PaintingStyle.stroke;
    paint.color = Colors.black54;
    paint.strokeWidth = 1;
    
    canvas.drawPath(greenPath, paint);
    canvas.drawPath(bluePath, paint);
    canvas.drawPath(yellowPath, paint);
    canvas.drawPath(redPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
