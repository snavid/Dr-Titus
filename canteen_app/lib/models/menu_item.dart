class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  final bool isAvailable;
  final bool isVeg;
  final double rating;
  final int prepTimeMinutes;
  final List<String> tags;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    this.isAvailable = true,
    this.isVeg = true,
    this.rating = 4.0,
    this.prepTimeMinutes = 15,
    this.tags = const [],
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String,
      imageUrl: json['imageUrl'] as String,
      isAvailable: json['isAvailable'] as bool? ?? true,
      isVeg: json['isVeg'] as bool? ?? true,
      rating: (json['rating'] ?? 4.0).toDouble(),
      prepTimeMinutes: json['prepTimeMinutes'] as int? ?? 15,
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'category': category,
        'imageUrl': imageUrl,
        'isAvailable': isAvailable,
        'isVeg': isVeg,
        'rating': rating,
        'prepTimeMinutes': prepTimeMinutes,
        'tags': tags,
      };
}


