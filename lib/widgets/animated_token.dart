import 'package:flutter/material.dart';

import 'game_piece.dart';

class AnimatedToken extends StatefulWidget {
  final int player;
  final int piece;
  final double cellSize;
  final Color color;
  final int progress;
  final bool canSelect;
  final VoidCallback? onTap;
  final List<Offset> path;
  final Offset offset;
  final double tokenSize;

  const AnimatedToken({
    super.key,
    required this.player,
    required this.piece,
    required this.cellSize,
    required this.color,
    required this.progress,
    required this.canSelect,
    required this.onTap,
    required this.path,
    required this.offset,
    required this.tokenSize,
  });

  @override
  State<AnimatedToken> createState() => _AnimatedTokenState();
}

class _AnimatedTokenState extends State<AnimatedToken>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Animation<Offset>? _positionAnimation;
  Animation<double>? _jumpAnimation;
  Animation<double>? _scaleAnimation;
  int? _lastProgress;
  int _currentAnimatingProgress = 0;

  @override
  void initState() {
    super.initState();
    _lastProgress = widget.progress;
    _currentAnimatingProgress = widget.progress;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _setupAnimations();
  }

  void _setupAnimations() {
    final startIndex = _currentAnimatingProgress.clamp(0, widget.path.length - 1);
    final endIndex = (_currentAnimatingProgress + 1).clamp(0, widget.path.length - 1);

    _positionAnimation = Tween<Offset>(
      begin: widget.path[startIndex],
      end: widget.path[endIndex],
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Create a jump animation - arc motion
    _jumpAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: -25.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -25.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50.0,
      ),
    ]).animate(_controller);

    // Add a subtle scale animation
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.15)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.15, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50.0,
      ),
    ]).animate(_controller);
  }

  @override
  void didUpdateWidget(AnimatedToken oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (_lastProgress != null && widget.progress != _lastProgress) {
      if (widget.progress > _lastProgress!) {
        _animateToProgress(widget.progress);
      } else {
        _currentAnimatingProgress = widget.progress;
      }
    }
    _lastProgress = widget.progress;
  }

  void _animateToProgress(int targetProgress) {
    if (_currentAnimatingProgress >= targetProgress) {
      return;
    }

    _currentAnimatingProgress++;
    _setupAnimations();
    
    _controller.forward(from: 0.0).then((_) {
      if (!mounted) return;
      
      if (_currentAnimatingProgress < targetProgress) {
        // Continue jumping to next cell
        _animateToProgress(targetProgress);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final pathIndex = _currentAnimatingProgress.clamp(0, widget.path.length - 1);
        final currentPos = _controller.isAnimating && _positionAnimation != null
            ? _positionAnimation!.value
            : widget.path[pathIndex];
        
        final left = currentPos.dx * widget.cellSize + 
                     widget.offset.dx + 
                     (widget.cellSize - widget.tokenSize) / 2;
        final top = currentPos.dy * widget.cellSize + 
                    widget.offset.dy + 
                    (widget.cellSize - widget.tokenSize) / 2;

        final jumpOffset = _controller.isAnimating && _jumpAnimation != null
            ? _jumpAnimation!.value
            : 0.0;
        
        final scale = _controller.isAnimating && _scaleAnimation != null
            ? _scaleAnimation!.value
            : 1.0;

        return Positioned(
          left: left,
          top: top,
          child: Transform.translate(
            offset: Offset(0, jumpOffset),
            child: Transform.scale(
              scale: scale,
              child: child,
            ),
          ),
        );
      },
      child: GestureDetector(
        onTap: widget.canSelect ? widget.onTap : null,
        child: GamePiece(
          color: widget.color,
          size: widget.tokenSize,
        ),
      ),
    );
  }
}
