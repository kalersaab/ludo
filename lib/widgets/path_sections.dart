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
                    // Only center column is colored for home stretch
                    color: col == 1 && ((isTop && row >= 1 && row <= 5) || (!isTop && row >= 0 && row <= 4))
                        ? color
                        : (col == (isTop ? 2 : 0) && row == (isTop ? 1 : 4))
                            ? color
                                : Colors.white,
                    // Mark star safe cells
                    isSafe: (isTop && col == 0 && row == 2) ||
                      (!isTop && col == 2 && row == 3),
                    isArrow: (col == 1 && row == (isTop ? 0 : 5)),
                    arrowDirection: isTop ? 'down' : 'up',
                    safeColor: color,
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
                    // Only center row is colored for home stretch
                    color: row == 1 && ((isLeft && col >= 1 && col <= 5) || (!isLeft && col >= 0 && col <= 4))
                        ? color
                        : (row == (isLeft ? 0 : 2) && col == (isLeft ? 1 : 4))
                            ? color
                            : Colors.white,
                    isSafe: (isLeft && row == 2 && col == 2) ||
                      (!isLeft && row == 0 && col == 3),
                    isArrow: (row == 1 && col == (isLeft ? 0 : 5)),
                    arrowDirection: isLeft ? 'right' : 'left',
                    safeColor: color,
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
