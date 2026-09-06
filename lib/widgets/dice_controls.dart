import 'dart:math' as math;

import 'package:flutter/material.dart';

class DiceControls extends StatefulWidget {
  final String currentPlayer;
  final int diceValue;
  final bool enabled;
  final VoidCallback onRollDice;

  const DiceControls({
    super.key,
    required this.currentPlayer,
    required this.diceValue,
    this.enabled = true,
    required this.onRollDice,
  });

  @override
  State<DiceControls> createState() => _DiceControlsState();
}

class _DiceControlsState extends State<DiceControls>
    with SingleTickerProviderStateMixin {
  late final AnimationController _rollController;
  final math.Random _random = math.Random();
  List<int> _rollFaces = [1];

  @override
  void initState() {
    super.initState();
    _rollController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
  }

  @override
  void dispose() {
    _rollController.dispose();
    super.dispose();
  }

  void _rollDice() {
    if (!widget.enabled || _rollController.isAnimating) {
      return;
    }

    widget.onRollDice();
    setState(() {
      _rollFaces = List.generate(12, (_) => _random.nextInt(6) + 1);
    });
    _rollController.forward(from: 0);
  }

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
    final playerColor = _getPlayerColor(widget.currentPlayer);
    final isLeftPlayer = widget.currentPlayer == 'Blue';
    final isRightPlayer = widget.currentPlayer == 'Green';
    final isVerticalLayout = isLeftPlayer || isRightPlayer;

    if (isVerticalLayout) {
      // Vertical layout for left/right players
      return Container(
        width: 70,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        decoration: BoxDecoration(
          color: playerColor.withValues(alpha: 0.08),
          border: Border(
            left: isLeftPlayer ? BorderSide.none : const BorderSide(color: Colors.black12, width: 1),
            right: isLeftPlayer ? const BorderSide(color: Colors.black12, width: 1) : BorderSide.none,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Dice
            SizedBox(
              width: 50,
              height: 50,
              child: Opacity(
                opacity: widget.enabled ? 1 : 0.5,
                child: GestureDetector(
                  onTap: widget.enabled ? _rollDice : null,
                  child: AnimatedBuilder(
                    animation: _rollController,
                    builder: (context, child) {
                      final progress = _rollController.value;
                      final faceIndex = math.min(
                        (progress * _rollFaces.length).floor(),
                        _rollFaces.length - 1,
                      );
                      final faceValue = progress == 1
                          ? widget.diceValue
                          : _rollFaces[faceIndex];
                      final rotation =
                          math.sin(progress * math.pi * 12) *
                          (1 - progress) *
                          0.25;
                      final scale = 1 - math.sin(progress * math.pi) * 0.15;
                      final offset =
                          math.sin(progress * math.pi * 8) * (1 - progress) * 2;

                      return Transform.translate(
                        offset: Offset(offset, 0),
                        child: Transform.rotate(
                          angle: rotation,
                          child: Transform.scale(
                            scale: scale,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: playerColor,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: playerColor.withValues(alpha: 0.4),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 2,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: _buildDiceFace(faceValue),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            // Location pin
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: Colors.green.shade600,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.location_on,
                  color: Colors.green.shade600,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      // Horizontal layout for top/bottom players - fixed width
      return Container(
        width: 114,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: playerColor.withValues(alpha: 0.08),
          border: Border(
            top: widget.currentPlayer == 'Yellow' ? const BorderSide(color: Colors.black12, width: 1) : BorderSide.none,
            bottom: widget.currentPlayer == 'Red' ? const BorderSide(color: Colors.black12, width: 1) : BorderSide.none,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Dice on the left
            SizedBox(
              width: 50,
              height: 50,
              child: Opacity(
                opacity: widget.enabled ? 1 : 0.5,
                child: GestureDetector(
                  onTap: widget.enabled ? _rollDice : null,
                  child: AnimatedBuilder(
                    animation: _rollController,
                    builder: (context, child) {
                      final progress = _rollController.value;
                      final faceIndex = math.min(
                        (progress * _rollFaces.length).floor(),
                        _rollFaces.length - 1,
                      );
                      final faceValue = progress == 1
                          ? widget.diceValue
                          : _rollFaces[faceIndex];
                      final rotation =
                          math.sin(progress * math.pi * 12) *
                          (1 - progress) *
                          0.25;
                      final scale = 1 - math.sin(progress * math.pi) * 0.15;
                      final offset =
                          math.sin(progress * math.pi * 8) * (1 - progress) * 2;

                      return Transform.translate(
                        offset: Offset(offset, 0),
                        child: Transform.rotate(
                          angle: rotation,
                          child: Transform.scale(
                            scale: scale,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: playerColor,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: playerColor.withValues(alpha: 0.4),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 2,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: _buildDiceFace(faceValue),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            // Location pin indicator on the right
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: Colors.green.shade600,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.location_on,
                  color: Colors.green.shade600,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildDiceFace(int value) {
    return CustomPaint(size: const Size(40, 40), painter: DicePainter(value));
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
