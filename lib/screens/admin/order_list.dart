import 'package:flutter/material.dart';
import 'package:my_app/model/admin_order_placement.dart';
import 'package:my_app/services/database_service.dart';

class OrderList extends StatefulWidget {
  const OrderList({super.key});

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  final DatabaseService _databaseService = DatabaseService();
  late Future<List<AdminOrder>> _adminOrderList;

  @override
  void initState() {
    super.initState();
    _adminOrderList = _databaseService.getAllAdminOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order List'),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 187, 206, 101),
              Color.fromARGB(255, 187, 206, 101),
              Color.fromARGB(255, 238, 172, 49),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder<List<AdminOrder>>(
          future: _adminOrderList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No orders found'));
            } else {
              final orders = snapshot.data!;
              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Card(
                    child: ListTile(
                      title: Text(
                        order.itemName,
                        style: TextStyle(color: Colors.black),
                      ),
                      subtitle: Text(
                        'Quantity: ${order.quantity}',
                        style: TextStyle(color: Colors.black),
                      ),
                      trailing: Text(
                        order.status,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
