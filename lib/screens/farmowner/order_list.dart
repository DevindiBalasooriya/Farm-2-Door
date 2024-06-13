import 'package:flutter/material.dart';
import 'package:my_app/model/order.dart';
import 'package:my_app/model/customer_order.dart';

class FarmOrderList extends StatefulWidget {
  const FarmOrderList({super.key});

  @override
  State<FarmOrderList> createState() => _FarmOrderListState();
}

class _FarmOrderListState extends State<FarmOrderList> {
  final OrderRepository orderRepo = OrderRepository.instance;

  void _acceptOrder(int index) {
    orderRepo.orders[index].status = 'Accepted';
  }

  void _rejectOrder(int index) {
    orderRepo.orders[index].status = 'Not Accepted';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Farm Owner Order List'),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
        ), // Body background color
        padding: EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: orderRepo.orders.length,
          itemBuilder: (context, index) {
            final order = orderRepo.orders[index];
            return Card(
              child: ListTile(
                title: Text(order.itemName,
                    style: TextStyle(color: Colors.black)), // Text color
                subtitle: Text('Quantity: ${order.quantity}',
                    style: TextStyle(color: Colors.black)), // Text color
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _acceptOrder(index);
                        (context as Element).reassemble();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Button color
                      ),
                      child:
                          Text('Accept', style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        _rejectOrder(index);
                        (context as Element).reassemble();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Button color
                      ),
                      child:
                          Text('Reject', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
