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
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.black87,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
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
                      color: const Color(0xFFFF0000),
                      size: cellSize * 6,
                    ),
                  ),
                  
                  // Green Home (Top-Right)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: HomeArea(
                      color: const Color(0xFF00C853),
                      size: cellSize * 6,
                    ),
                  ),
                  
                  // Yellow Home (Bottom-Left) - Actually this should be Blue
                  Positioned(
                    left: 0,
                    bottom: 0,
                    child: HomeArea(
                      color: const Color(0xFF2196F3),
                      size: cellSize * 6,
                    ),
                  ),
                  
                  // Blue Home (Bottom-Right) - Actually this should be Yellow
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: HomeArea(
                      color: const Color(0xFFFFEB3B),
                      size: cellSize * 6,
                    ),
                  ),
                  
                  // Vertical Paths
                  Positioned(
                    left: cellSize * 6,
                    top: 0,
                    child: VerticalPath(
                      color: const Color(0xFF00C853),
                      cellSize: cellSize,
                      isTop: true,
                    ),
                  ),
                  Positioned(
                    left: cellSize * 6,
                    bottom: 0,
                    child: VerticalPath(
                      color: const Color(0xFF2196F3),
                      cellSize: cellSize,
                      isTop: false,
                    ),
                  ),
                  
                  // Horizontal Paths
                  Positioned(
                    left: 0,
                    top: cellSize * 6,
                    child: HorizontalPath(
                      color: const Color(0xFFFF0000),
                      cellSize: cellSize,
                      isLeft: true,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: cellSize * 6,
                    child: HorizontalPath(
                      color: const Color(0xFFFFEB3B),
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
      ),
    );
  }
}
