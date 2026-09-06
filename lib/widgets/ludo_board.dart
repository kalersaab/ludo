import 'package:flutter/material.dart';

import 'home_area.dart';
import 'center_area.dart';
import 'animated_token.dart';
import 'path_sections.dart';

class LudoBoard extends StatelessWidget {
  final String currentPlayer;
  final int diceValue;
  final List<Set<int>> movedPieces;
  final List<Map<int, int>> piecePositions;
  final int playerCount;
  final bool canSelectTokens;
  final ValueChanged<int> onTokenTap;

  const LudoBoard({
    super.key,
    required this.currentPlayer,
    required this.diceValue,
    required this.movedPieces,
    required this.piecePositions,
    required this.playerCount,
    required this.canSelectTokens,
    required this.onTokenTap,
  });

  int _playerIndex(String player) {
    return <String>['Red', 'Green', 'Blue', 'Yellow'].indexOf(player);
  }

  List<Offset> _cellPath(List<int> numbers) {
    return numbers.map((number) {
      final zeroBased = number - 1;
      return Offset((zeroBased % 15).toDouble(), (zeroBased ~/ 15).toDouble());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black87, width: 3),
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
              final redColor = const Color(0xFFFF0000);
              final greenColor = const Color(0xFF00C853);
              final blueColor = const Color(0xFF2196F3);
              final yellowColor = const Color(0xFFFFEB3B);
              final colors = <Color>[
                redColor,
                greenColor,
                blueColor,
                yellowColor,
              ];

              Widget homeArea(Color color, Alignment alignment, int player) {
                return Positioned.fill(
                  child: Align(
                    alignment: alignment,
                    child: HomeArea(
                      color: color,
                      size: cellSize * 6,
                      canMove:
                          canSelectTokens &&
                          diceValue == 6 &&
                          activePlayerIndex == player,
                      showTokens: player < playerCount,
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

                  homeArea(colors[0], Alignment.topLeft, 0),

                  homeArea(colors[1], Alignment.topRight, 1),

                  homeArea(blueColor, Alignment.bottomLeft, 2),

                  homeArea(yellowColor, Alignment.bottomRight, 3),

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

                  for (int player = 0; player < playerCount; player++)
                    for (final piece in movedPieces[player])
                      _buildMovedToken(
                        player,
                        piece,
                        cellSize,
                        colors[player],
                        piecePositions[player][piece] ?? 0,
                        canSelectTokens && activePlayerIndex == player,
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
    int progress,
    bool canSelect,
  ) {
    final mainPaths = <List<Offset>>[
      _cellPath([
        92,
        93,
        94,
        95,
        96,
        82,
        67,
        52,
        37,
        22,
        7,
        8,
        9,
        24,
        39,
        54,
        69,
        84,
        100,
        101,
        102,
        103,
        104,
        105,
        120,
        135,
        134,
        133,
        132,
        131,
        130,
        144,
        159,
        174,
        189,
        204,
        219,
        218,
        217,
        202,
        187,
        172,
        157,
        142,
        126,
        125,
        124,
        123,
        122,
        121,
        106,
        107,
        108,
        109,
        110,
        111,
        112,
      ]),
      _cellPath([
        24,
        39,
        54,
        69,
        84,
        100,
        101,
        102,
        103,
        104,
        105,
        120,
        135,
        134,
        133,
        132,
        131,
        130,
        144,
        159,
        174,
        189,
        204,
        219,
        218,
        217,
        202,
        187,
        172,
        157,
        142,
        126,
        125,
        124,
        123,
        122,
        121,
        106,
        91,
        92,
        93,
        94,
        95,
        96,
        82,
        67,
        52,
        37,
        22,
        7,
        8,
        23,
        38,
        53,
        68,
        83,
        98,
      ]),
      _cellPath([
        134,
        133,
        132,
        131,
        130,
        144,
        159,
        174,
        189,
        204,
        219,
        218,
        217,
        202,
        187,
        172,
        157,
        142,
        126,
        125,
        124,
        123,
        122,
        121,
        106,
        91,
        92,
        93,
        94,
        95,
        96,
        82,
        67,
        52,
        37,
        22,
        7,
        8,
        9,
        24,
        39,
        54,
        69,
        84,
        100,
        101,
        102,
        103,
        104,
        105,
        120,
        119,
        118,
        117,
        116,
        115,
        114,
      ]),
      _cellPath([
        202,
        187,
        172,
        157,
        142,
        126,
        125,
        124,
        123,
        122,
        121,
        106,
        91,
        92,
        93,
        94,
        95,
        96,
        82,
        67,
        52,
        37,
        22,
        7,
        8,
        9,
        24,
        39,
        54,
        69,
        84,
        100,
        101,
        102,
        103,
        104,
        105,
        120,
        135,
        134,
        133,
        132,
        131,
        130,
        144,
        159,
        174,
        189,
        204,
        219,
        218,
        203,
        188,
        173,
        158,
        143,
        128,
      ]),
    ];
    final homeLanes = <List<Offset>>[
      _cellPath([106, 107, 108, 109, 110, 111, 112]),
      _cellPath([8, 23, 38, 53, 68, 83, 98]),
      _cellPath([218, 203, 188, 173, 158, 143, 128]),
      _cellPath([120, 119, 118, 117, 116, 115, 114]),
    ];
    final routeIndexByPlayer = <int>[0, 1, 3, 2];
    final routeIndex = routeIndexByPlayer[player];
    final path = <Offset>[...mainPaths[routeIndex], ...homeLanes[routeIndex]];
    final visibleProgress = progress;
    final pathIndex = visibleProgress.clamp(0, path.length - 1).toInt();
    final isFinished = pathIndex == path.length - 1;
    final tokenSize = cellSize * 0.7;
    final offset = Offset(
      (piece % 2) * cellSize * 0.18,
      (piece ~/ 2) * cellSize * 0.18,
    );

    return AnimatedToken(
      key: ValueKey('token_${player}_$piece'),
      player: player,
      piece: piece,
      cellSize: cellSize,
      color: color,
      progress: progress,
      canSelect: canSelect && !isFinished,
      onTap: canSelect && !isFinished ? () => onTokenTap(piece) : null,
      path: path,
      offset: offset,
      tokenSize: tokenSize,
    );
  }
}
