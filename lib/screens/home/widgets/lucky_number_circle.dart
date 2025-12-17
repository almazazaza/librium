import 'package:flutter/material.dart';

class LuckyNumberCircle extends StatefulWidget {
  final int luckyNumber;
  final bool isLucky;
  final ThemeData theme;

  const LuckyNumberCircle({
    super.key,
    required this.luckyNumber,
    required this.isLucky,
    required this.theme,
  });

  @override
  State<LuckyNumberCircle> createState() => _LuckyNumberCircleState();
}

class _LuckyNumberCircleState extends State<LuckyNumberCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _glowAnimation = Tween<double>(begin: 2, end: 6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.isLucky) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant LuckyNumberCircle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLucky && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.isLucky && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        final glowBlur = _glowAnimation.value;
        return Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.isLucky
                ? Colors.amber
                : widget.theme.colorScheme.primary,
            boxShadow: widget.isLucky
                ? [
                    BoxShadow(
                      color: Colors.amber.withValues(alpha: 0.35),
                      blurRadius: glowBlur,
                      spreadRadius: glowBlur / 3,
                      offset: const Offset(0, 0),
                    ),
                  ]
                : [],
          ),
          child: Text(
            "${widget.luckyNumber}",
            style: TextStyle(
              color: widget.isLucky
                  ? widget.theme.appBarTheme.backgroundColor
                  : widget.theme.appBarTheme.foregroundColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            )
          )
        );
      }
    );
  }
}