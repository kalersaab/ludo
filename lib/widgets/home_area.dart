import 'package:flutter/material.dart';

import 'game_piece.dart';

class HomeArea extends StatelessWidget {
  final Color color;
  final double size;

  const HomeArea({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.black54, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(size * 0.12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(size * 0.05),
            border: Border.all(color: Colors.grey.shade300, width: 2),
          ),
          child: GridView.count(
            crossAxisCount: 2,
            padding: EdgeInsets.all(size * 0.08),
            mainAxisSpacing: size * 0.08,
            crossAxisSpacing: size * 0.08,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(
              4,
              (index) => Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 1.5,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(size * 0.02),
                  child: GamePiece(color: color, size: size * 0.16),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
