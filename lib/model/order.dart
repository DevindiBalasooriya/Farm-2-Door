class Order {
  final String itemName;
  final int quantity;
  String status; // Ordered, Confirmed, Accepted, Not Accepted

  Order(
      {required this.itemName,
      required this.quantity,
      this.status = 'Ordered'});
}
