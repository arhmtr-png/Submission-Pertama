// Models: Restaurant
// Contains only the fields required by the PRD and mapping helpers for
// JSON (API) and Map (SQLite) interchange.
import 'package:flutter/foundation.dart';

@immutable
class Restaurant {
  final String id;
  final String name;
  final String pictureId;
  final String city;
  final double rating;

  const Restaurant({
    required this.id,
    required this.name,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  /// Create a [Restaurant] from API JSON.
  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      pictureId: json['pictureId'] as String? ?? '',
      city: json['city'] as String? ?? '',
      rating: (json['rating'] is num) ? (json['rating'] as num).toDouble() : double.tryParse('${json['rating']}') ?? 0.0,
    );
  }

  /// Create a [Restaurant] from a SQLite row (Map).
  factory Restaurant.fromMap(Map<String, dynamic> map) {
    return Restaurant(
      id: map['id'] as String,
      name: map['name'] as String? ?? '',
      pictureId: map['pictureId'] as String? ?? '',
      city: map['city'] as String? ?? '',
      rating: (map['rating'] is num) ? (map['rating'] as num).toDouble() : double.tryParse('${map['rating']}') ?? 0.0,
    );
  }

  /// Convert to JSON for API requests.
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'pictureId': pictureId,
        'city': city,
        'rating': rating,
      };

  /// Convert to Map for SQLite insertion/update.
  Map<String, dynamic> toMap() => toJson();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Restaurant &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          pictureId == other.pictureId &&
          city == other.city &&
          rating == other.rating;

  @override
  int get hashCode => Object.hash(id, name, pictureId, city, rating);
}
