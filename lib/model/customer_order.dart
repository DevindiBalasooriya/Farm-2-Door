import 'package:my_app/model/order.dart';

import 'customer_order.dart';

class OrderRepository {
  static final OrderRepository _instance = OrderRepository._internal();
  final List<Order> orders = [];

  OrderRepository._internal();

  static OrderRepository get instance => _instance;
}
