import 'package:flutter/material.dart';
import 'dart:math' as math;

/// A simple star rating widget that supports full, half and empty stars.
///
/// Usage: StarRating(rating: 4.5, size: 18, color: Colors.amber)
class StarRating extends StatelessWidget {
  final double rating; // 0..starCount
  final int starCount;
  final double size;
  final Color? color;
  final MainAxisAlignment alignment;

  const StarRating({
    Key? key,
    required this.rating,
    this.starCount = 5,
    this.size = 18,
    this.color,
    this.alignment = MainAxisAlignment.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Round rating to nearest 0.5 for conventional display
    final rounded = (rating * 2).roundToDouble() / 2.0;
    final cs = color ?? Theme.of(context).colorScheme.primary;
    final stars = List<Widget>.generate(starCount, (index) {
      final starIndex = index + 1;
      final fill = (rounded - (starIndex - 1)).clamp(0.0, 1.0);
      return FractionalStar(fraction: fill, size: size, color: cs);
    });

    return Semantics(
      label: 'Rating: ${rating.toStringAsFixed(1)} out of $starCount',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: alignment,
        children: stars,
      ),
    );
  }
}

class FractionalStar extends StatelessWidget {
  final double fraction; // 0.0 .. 1.0
  final double size;
  final Color color;

  const FractionalStar({
    Key? key,
    required this.fraction,
    required this.size,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _StarPainter(fraction: fraction, color: color),
      ),
    );
  }
}

class _StarPainter extends CustomPainter {
  final double fraction;
  final Color color;

  _StarPainter({required this.fraction, required this.color});

  Path _starPath(Rect rect) {
    // Simple 5-point star path centered in rect
    final cx = rect.center.dx;
    final cy = rect.center.dy;
    final r = rect.width / 2;
    final innerR = r * 0.5;
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final outerAngle = (i * 72 - 90) * math.pi / 180.0;
      final innerAngle = (i * 72 + 36 - 90) * math.pi / 180.0;
      final ox = cx + r * math.cos(outerAngle);
      final oy = cy + r * math.sin(outerAngle);
      final ix = cx + innerR * math.cos(innerAngle);
      final iy = cy + innerR * math.sin(innerAngle);
      if (i == 0) {
        path.moveTo(ox, oy);
      } else {
        path.lineTo(ox, oy);
      }
      path.lineTo(ix, iy);
    }
    path.close();
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final star = _starPath(rect);
    final paintBg = Paint()..color = color.withAlpha(60);
    canvas.drawPath(star, paintBg);

    if (fraction > 0) {
      final paintFg = Paint()..color = color;
      // Clip the star to the fractional width
      final clipRect = Rect.fromLTWH(0, 0, size.width * fraction, size.height);
      canvas.save();
      canvas.clipRect(clipRect);
      canvas.drawPath(star, paintFg);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _StarPainter old) {
    return old.fraction != fraction || old.color != color;
  }
}
