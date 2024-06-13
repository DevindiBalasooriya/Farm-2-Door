class AdminOrder {
  String? id;
  int quantity;
  String itemName;
  String farmerEmail;
  String status;
  double totalPrice;

  AdminOrder({
    this.id,
    required this.quantity,
    required this.itemName,
    required this.farmerEmail,
    required this.status,
    required this.totalPrice,
  });

  AdminOrder.fromJson(Map<String, Object?> json)
      : this(
          id: json['id'] as String?,
          quantity: json['quantity'] as int,
          itemName: json['itemName'] as String,
          farmerEmail: json['farmerEmail'] as String,
          status: json['status'] as String,
          totalPrice: json['totalPrice'] as double,
        );

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      'itemName': itemName,
      'farmerEmail': farmerEmail,
      'status': status,
      'totalPrice': totalPrice,
    };
  }
}
