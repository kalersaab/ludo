import 'package:flutter/material.dart';

class PathCell extends StatelessWidget {
  final double cellSize;
  final Color color;
  final bool isSafe;
  final bool isArrow;

  const PathCell({
    super.key,
    required this.cellSize,
    required this.color,
    this.isSafe = false,
    this.isArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cellSize,
      height: cellSize,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.grey.shade300, width: 0.5),
      ),
      child: isSafe
          ? Icon(
              Icons.star,
              color: Colors.white,
              size: cellSize * 0.5,
            )
          : isArrow
              ? Icon(
                  Icons.arrow_upward,
                  color: Colors.black45,
                  size: cellSize * 0.4,
                )
              : null,
    );
  }
}
