class Item {
  final String? id; // Firestore document ID
  final String title;
  final String category;
  double price;
  bool available;
  int quantity;

  Item({
    this.id,
    required this.title,
    required this.category,
    required this.price,
    this.available = true,
    this.quantity = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'price': price,
      'available': available,
      'quantity': quantity,
    };
  }

  factory Item.fromJson(Map<String, dynamic> json, String id) {
    return Item(
      id: id,
      title: json['title'],
      category: json['category'],
      price: (json['price'] as num).toDouble(), // Convert to double
      available: json['available'],
      quantity: json['quantity'],
    );
  }
}
