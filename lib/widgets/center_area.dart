import 'package:flutter/material.dart';

class CenterArea extends StatelessWidget {
  final double size;

  const CenterArea({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          // Four colored triangles
          CustomPaint(
            size: Size(size, size),
            painter: CenterTrianglePainter(),
          ),
          // Center star
          Center(
            child: Container(
              width: size * 0.4,
              height: size * 0.4,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.star,
                color: Colors.amber,
                size: size * 0.3,
              ),
            ),
          ),
        ],
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
    paint.color = Colors.green;
    final greenPath = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(center.dx, center.dy)
      ..close();
    canvas.drawPath(greenPath, paint);
    
    // Yellow triangle (left)
    paint.color = Colors.yellow;
    final yellowPath = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height)
      ..lineTo(center.dx, center.dy)
      ..close();
    canvas.drawPath(yellowPath, paint);
    
    // Blue triangle (right)
    paint.color = Colors.blue;
    final bluePath = Path()
      ..moveTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(center.dx, center.dy)
      ..close();
    canvas.drawPath(bluePath, paint);
    
    // Red triangle (bottom)
    paint.color = Colors.red;
    final redPath = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(center.dx, center.dy)
      ..close();
    canvas.drawPath(redPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
