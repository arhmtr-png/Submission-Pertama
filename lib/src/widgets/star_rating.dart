import 'package:flutter/material.dart';

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
    final cs = color ?? Theme.of(context).colorScheme.primary;
    final stars = List<Widget>.generate(starCount, (index) {
      final starIndex = index + 1;
      final diff = rating - (starIndex - 1);
      final icon = diff >= 0.75
          ? Icons.star
          : diff >= 0.25
          ? Icons.star_half
          : Icons.star_border;
      return Icon(icon, color: cs, size: size);
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
