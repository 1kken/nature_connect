class MarketplaceItem {
  final String id;
  final String userId;
  final String title;
  final String caption;
  final double price;
  final int stock;
  final DateTime createdAt;

  MarketplaceItem({
    required this.id,
    required this.userId,
    required this.title,
    required this.caption,
    required this.price,
    required this.stock,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'caption': caption,
      'price': price,
      'stock': stock,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory MarketplaceItem.fromMap(Map<String, dynamic> map) {
    return MarketplaceItem(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      caption: map['caption'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      stock: map['stock'] ?? 0,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }
}