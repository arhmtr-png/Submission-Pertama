class MenuItem {
  final String name;

  MenuItem({required this.name});

  factory MenuItem.fromJson(Map<String, dynamic> json) =>
      MenuItem(name: json['name'] as String);
}

class CustomerReview {
  final String name;
  final String review;
  final String date;

  CustomerReview({
    required this.name,
    required this.review,
    required this.date,
  });

  factory CustomerReview.fromJson(Map<String, dynamic> json) => CustomerReview(
    name: json['name'] as String,
    review: json['review'] as String,
    date: json['date'] as String,
  );
}

class RestaurantDetail {
  final String id;
  final String name;
  final String description;
  final String city;
  final String address;
  final double rating;
  final List<MenuItem> foods;
  final List<MenuItem> drinks;
  final List<CustomerReview> customerReviews;

  RestaurantDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.rating,
    required this.foods,
    required this.drinks,
    required this.customerReviews,
  });

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) {
    final menus = json['menus'] as Map<String, dynamic>? ?? {};
    final foods =
        (menus['foods'] as List<dynamic>?)
            ?.map((e) => MenuItem.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    final drinks =
        (menus['drinks'] as List<dynamic>?)
            ?.map((e) => MenuItem.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    final reviews =
        (json['customerReviews'] as List<dynamic>?)
            ?.map((e) => CustomerReview.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return RestaurantDetail(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      city: json['city'] as String,
      address: json['address'] as String,
      rating: (json['rating'] as num).toDouble(),
      foods: foods,
      drinks: drinks,
      customerReviews: reviews,
    );
  }
}
