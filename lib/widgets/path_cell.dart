import 'package:flutter/material.dart';

class PathCell extends StatelessWidget {
  final double cellSize;
  final Color color;
  final bool isSafe;
  final bool isArrow;
  final String? arrowDirection;
  final Color? safeColor;

  const PathCell({
    super.key,
    required this.cellSize,
    required this.color,
    this.isSafe = false,
    this.isArrow = false,
    this.arrowDirection,
    this.safeColor,
  });

  IconData _getArrowIcon() {
    switch (arrowDirection) {
      case 'up':
        return Icons.arrow_upward;
      case 'down':
        return Icons.arrow_downward;
      case 'left':
        return Icons.arrow_back;
      case 'right':
        return Icons.arrow_forward;
      default:
        return Icons.arrow_upward;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cellSize,
      height: cellSize,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: Colors.grey.shade400,
          width: 0.5,
        ),
      ),
      child: Stack(
        children: [
          if (isSafe)
            Center(
              child: Icon(
                Icons.star,
                color: safeColor ?? Colors.amber.shade700,
                size: cellSize * 0.6,
              ),
            ),
          if (isArrow)
            Center(
              child: Icon(
                _getArrowIcon(),
                color: Colors.black54,
                size: cellSize * 0.5,
              ),
            ),
        ],
      ),
    );
  }
}
