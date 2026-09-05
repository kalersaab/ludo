import 'package:flutter/material.dart';

class DiceControls extends StatelessWidget {
  final String currentPlayer;
  final int diceValue;
  final VoidCallback onRollDice;

  const DiceControls({
    super.key,
    required this.currentPlayer,
    required this.diceValue,
    required this.onRollDice,
  });

  Color _getPlayerColor(String player) {
    switch (player) {
      case 'Red':
        return const Color(0xFFFF0000);
      case 'Green':
        return const Color(0xFF00C853);
      case 'Yellow':
        return const Color(0xFFFFEB3B);
      case 'Blue':
        return const Color(0xFF2196F3);
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _getPlayerColor(currentPlayer),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$currentPlayer\'s Turn',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 24),
          GestureDetector(
            onTap: onRollDice,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.grey.shade400,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: _buildDiceFace(diceValue),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiceFace(int value) {
    return CustomPaint(
      size: const Size(60, 60),
      painter: DicePainter(value),
    );
  }
}

class DicePainter extends CustomPainter {
  final int value;

  DicePainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final double dotRadius = size.width * 0.08;
    final double padding = size.width * 0.2;
    final double center = size.width / 2;

    void drawDot(double x, double y) {
      canvas.drawCircle(Offset(x, y), dotRadius, paint);
    }

    switch (value) {
      case 1:
        drawDot(center, center);
        break;
      case 2:
        drawDot(padding, padding);
        drawDot(size.width - padding, size.height - padding);
        break;
      case 3:
        drawDot(padding, padding);
        drawDot(center, center);
        drawDot(size.width - padding, size.height - padding);
        break;
      case 4:
        drawDot(padding, padding);
        drawDot(size.width - padding, padding);
        drawDot(padding, size.height - padding);
        drawDot(size.width - padding, size.height - padding);
        break;
      case 5:
        drawDot(padding, padding);
        drawDot(size.width - padding, padding);
        drawDot(center, center);
        drawDot(padding, size.height - padding);
        drawDot(size.width - padding, size.height - padding);
        break;
      case 6:
        drawDot(padding, padding);
        drawDot(size.width - padding, padding);
        drawDot(padding, center);
        drawDot(size.width - padding, center);
        drawDot(padding, size.height - padding);
        drawDot(size.width - padding, size.height - padding);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
