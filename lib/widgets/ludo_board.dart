import 'package:flutter/material.dart';

import 'home_area.dart';
import 'center_area.dart';
import 'game_piece.dart';
import 'path_sections.dart';

class LudoBoard extends StatelessWidget {
  final String currentPlayer;
  final int diceValue;
  final List<Set<int>> movedPieces;
  final ValueChanged<int> onTokenTap;

  const LudoBoard({
    super.key,
    required this.currentPlayer,
    required this.diceValue,
    required this.movedPieces,
    required this.onTokenTap,
  });

  int _playerIndex(String player) {
    return <String>['Red', 'Green', 'Blue', 'Yellow'].indexOf(player);
  }

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
              final activePlayerIndex = _playerIndex(currentPlayer);
              final colors = <Color>[
                const Color(0xFFFF0000),
                const Color(0xFF00C853),
                const Color(0xFF2196F3),
                const Color(0xFFFFEB3B),
              ];

              Widget homeArea(Color color, Alignment alignment, int player) {
                return Positioned.fill(
                  child: Align(
                    alignment: alignment,
                    child: HomeArea(
                      color: color,
                      size: cellSize * 6,
                      canMove: diceValue == 6 && activePlayerIndex == player,
                      movedPieces: movedPieces[player],
                      onTokenTap: onTokenTap,
                    ),
                  ),
                );
              }

              return Stack(
                children: [
                  // Background
                  Container(color: Colors.white),
                  
                  // Red Home (Top-Left)
                  homeArea(colors[0], Alignment.topLeft, 0),
                  
                  // Green Home (Top-Right)
                  homeArea(colors[1], Alignment.topRight, 1),
                  
                  // Yellow Home (Bottom-Left) - Actually this should be Blue
                  homeArea(colors[2], Alignment.bottomLeft, 2),
                  
                  // Blue Home (Bottom-Right) - Actually this should be Yellow
                  homeArea(colors[3], Alignment.bottomRight, 3),
                  
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

                  for (int player = 0; player < 4; player++)
                    for (final piece in movedPieces[player])
                      _buildMovedToken(
                        player,
                        piece,
                        cellSize,
                        colors[player],
                      ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMovedToken(
    int player,
    int piece,
    double cellSize,
    Color color,
  ) {
    final positions = <Offset>[
      Offset(0, cellSize * 7),
      Offset(cellSize * 7, 0),
      Offset(cellSize * 7, cellSize * 14),
      Offset(cellSize * 14, cellSize * 7),
    ];
    final base = positions[player];
    final offset = Offset(
      (piece % 2) * cellSize * 0.25,
      (piece ~/ 2) * cellSize * 0.25,
    );
    final tokenSize = cellSize * 0.8;

    return Positioned(
      left: base.dx + offset.dx + (cellSize - tokenSize) / 2,
      top: base.dy + offset.dy + (cellSize - tokenSize) / 2,
      child: IgnorePointer(
        child: GamePiece(color: color, size: tokenSize),
      ),
    );
  }
}
