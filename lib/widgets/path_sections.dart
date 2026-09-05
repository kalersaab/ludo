import 'package:flutter/material.dart';

import 'path_cell.dart';

class VerticalPath extends StatelessWidget {
  final Color color;
  final double cellSize;
  final bool isTop;

  const VerticalPath({
    super.key,
    required this.color,
    required this.cellSize,
    required this.isTop,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: cellSize * 3,
      height: cellSize * 6,
      child: Column(
        children: [
          for (int row = 0; row < 6; row++)
            Row(
              children: [
                for (int col = 0; col < 3; col++)
                  PathCell(
                    cellSize: cellSize,
                    color: (col == 1 && row == (isTop ? 1 : 4))
                        ? color
                        : (col == 1 ? color.withOpacity(0.3) : Colors.white),
                    isSafe: (col == 1 && row == (isTop ? 1 : 4)),
                    isArrow: (col == 1 && row == (isTop ? 0 : 5)),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class HorizontalPath extends StatelessWidget {
  final Color color;
  final double cellSize;
  final bool isLeft;

  const HorizontalPath({
    super.key,
    required this.color,
    required this.cellSize,
    required this.isLeft,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: cellSize * 6,
      height: cellSize * 3,
      child: Column(
        children: [
          for (int row = 0; row < 3; row++)
            Row(
              children: [
                for (int col = 0; col < 6; col++)
                  PathCell(
                    cellSize: cellSize,
                    color: (row == 1 && col == (isLeft ? 1 : 4))
                        ? color
                        : (row == 1 ? color.withOpacity(0.3) : Colors.white),
                    isSafe: (row == 1 && col == (isLeft ? 1 : 4)),
                    isArrow: (row == 1 && col == (isLeft ? 0 : 5)),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
