import 'package:flutter/material.dart';

import 'home_area.dart';
import 'center_area.dart';
import 'path_sections.dart';

class LudoBoard extends StatelessWidget {
  const LudoBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = constraints.maxWidth;
            final cellSize = size / 15;

            return Stack(
              children: [
                // Background
                Container(color: Colors.white),
                
                // Red Home (Top-Left)
                Positioned(
                  left: 0,
                  top: 0,
                  child: HomeArea(
                    color: Colors.red,
                    size: cellSize * 6,
                  ),
                ),
                
                // Green Home (Top-Right)
                Positioned(
                  right: 0,
                  top: 0,
                  child: HomeArea(
                    color: Colors.green,
                    size: cellSize * 6,
                  ),
                ),
                
                // Yellow Home (Bottom-Left)
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: HomeArea(
                    color: Colors.yellow,
                    size: cellSize * 6,
                  ),
                ),
                
                // Blue Home (Bottom-Right)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: HomeArea(
                    color: Colors.blue,
                    size: cellSize * 6,
                  ),
                ),
                
                // Vertical Paths
                Positioned(
                  left: cellSize * 6,
                  top: 0,
                  child: VerticalPath(
                    color: Colors.green,
                    cellSize: cellSize,
                    isTop: true,
                  ),
                ),
                Positioned(
                  left: cellSize * 6,
                  bottom: 0,
                  child: VerticalPath(
                    color: Colors.yellow,
                    cellSize: cellSize,
                    isTop: false,
                  ),
                ),
                
                // Horizontal Paths
                Positioned(
                  left: 0,
                  top: cellSize * 6,
                  child: HorizontalPath(
                    color: Colors.red,
                    cellSize: cellSize,
                    isLeft: true,
                  ),
                ),
                Positioned(
                  right: 0,
                  top: cellSize * 6,
                  child: HorizontalPath(
                    color: Colors.blue,
                    cellSize: cellSize,
                    isLeft: false,
                  ),
                ),
                
                // Center Triangle
                Positioned(
                  left: cellSize * 6,
                  top: cellSize * 6,
                  child: CenterArea(size: cellSize * 3),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
