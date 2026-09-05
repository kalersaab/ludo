import 'dart:math' as math;

import 'package:flutter/material.dart';

class DiceControls extends StatefulWidget {
  final String currentPlayer;
  final int diceValue;
  final VoidCallback onRollDice;

  const DiceControls({
    super.key,
    required this.currentPlayer,
    required this.diceValue,
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
    if (_rollController.isAnimating) {
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

  Color _getPlayerTextColor(Color playerColor) {
    return playerColor.computeLuminance() > 0.55
        ? Colors.black87
        : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 360),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Container(
              constraints: const BoxConstraints(minHeight: 54),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: _getPlayerColor(widget.currentPlayer),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _getPlayerTextColor(
                        _getPlayerColor(widget.currentPlayer),
                      ).withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CURRENT TURN',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.1,
                            color: _getPlayerTextColor(
                              _getPlayerColor(widget.currentPlayer),
                            ).withValues(alpha: 0.75),
                          ),
                        ),
                        Text(
                          widget.currentPlayer,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: _getPlayerTextColor(
                              _getPlayerColor(widget.currentPlayer),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 76,
            height: 76,
            child: GestureDetector(
              onTap: _rollDice,
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
                    math.sin(progress * math.pi * 12) * (1 - progress) * 0.22;
                final scale = 1 - math.sin(progress * math.pi) * 0.12;
                final offset =
                    math.sin(progress * math.pi * 8) * (1 - progress) * 2;

                return Transform.translate(
                  offset: Offset(offset, 0),
                  child: Transform.rotate(
                    angle: rotation,
                    child: Transform.scale(
                      scale: scale,
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.shade400,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
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
