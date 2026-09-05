import 'package:flutter/material.dart';

class GamePiece extends StatelessWidget {
  final Color color;
  final double size;

  const GamePiece({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            bottom: 0,
            left: size * 0.08,
            right: size * 0.08,
            height: size * 0.58,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(size * 0.25),
                border: Border.all(
                  color: Colors.white,
                  width: size * 0.06,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: size * 0.12,
                    offset: Offset(0, size * 0.08),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Container(
              width: size * 0.52,
              height: size * 0.52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
                border: Border.all(
                  color: Colors.white,
                  width: size * 0.06,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: size * 0.1,
                    offset: Offset(0, size * 0.05),
                  ),
                ],
              ),
              child: Align(
                alignment: const Alignment(-0.35, -0.35),
                child: Container(
                  width: size * 0.12,
                  height: size * 0.12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.55),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
