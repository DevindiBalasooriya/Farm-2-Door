class CustomerOrder {
  String? id;
  int quantity;
  String itemName;
  String customerId;
  String status;
  int totalPrice;
  int onePrice;

  CustomerOrder({
    this.id,
    required this.quantity,
    required this.itemName,
    required this.customerId,
    required this.status,
    required this.onePrice,
    required this.totalPrice,
  });

  CustomerOrder.fromJson(Map<String, Object?> json)
      : this(
          id: json['id'] as String?,
          quantity: json['quantity'] as int,
          itemName: json['itemName'] as String,
          customerId: json['customerId'] as String,
          status: json['status'] as String,
          onePrice: json['onePrice'] as int,
          totalPrice: json['totalPrice'] as int,
        );

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      'itemName': itemName,
      'customerId': customerId,
      'status': status,
      'totalPrice': totalPrice,
      'onePrice': onePrice,
    };
  }
}
