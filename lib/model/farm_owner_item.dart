class FarmOwnerItem {
  final String? id;
  final String farmerName;
  final String itemName;
  final String category;
  int quantity;
  bool available;
  double price;

  FarmOwnerItem({
    this.id,
    required this.farmerName,
    required this.itemName,
    required this.category,
    required this.quantity,
    required this.available,
    required this.price,
  });

  factory FarmOwnerItem.fromJson(Map<String, dynamic> json, String id) {
    return FarmOwnerItem(
      id: id,
      farmerName: json['farmerName'] ?? '',
      itemName: json['itemName'] ?? '',
      category: json['category'] ?? '',
      quantity: json['quantity'] ?? 0,
      available: json['available'] ?? false,
      price: (json['price'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmerName': farmerName,
      'itemName': itemName,
      'category': category,
      'quantity': quantity,
      'available': available,
      'price': price,
    };
  }
}
