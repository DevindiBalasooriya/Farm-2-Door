class ItemUI {
  String? id;
  final String imageUrl;
  final String title;
  final double price;
  bool available;
  int quantity;

  ItemUI({
    this.id,
    required this.imageUrl,
    required this.title,
    required this.price,
    this.available = true,
    this.quantity = 0,
  });
  Map toJson() {
    return {
      'id': id,
      'title': title,
      'available': available,
      'quantity': quantity,
      'price': price,
      'imageUrl': imageUrl,
    };
  }
}
