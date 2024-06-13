import 'package:flutter/material.dart';
import 'package:my_app/model/item.dart';
import 'package:my_app/model/itemUI.dart';
import 'package:my_app/screens/customer/customer_screen.dart';
// Assuming you have a HomeScreen for customer home page

class CartScreen extends StatelessWidget {
  final List<ItemUI> cart;

  CartScreen({required this.cart});

  double get totalPrice {
    return cart.fold(
        0, (total, current) => total + (current.price * current.quantity));
  }

  void _checkout(BuildContext context) {
    // Store total price somewhere, for example, in a global variable or a database
    // Clear the cart
    cart.forEach((item) {
      item.quantity = 0;
    });
    cart.clear();

    // Show message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order placed successfully!')),
    );

    // Navigate to customer home page after a delay
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) =>
                CustomerHomeScreen()), // Update this to your home screen
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("My Cart"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.grey[200], // Background color for the body
        child: cart.isEmpty
            ? Center(
                child: Image.asset(
                  'assets/empty.png',
                  height: 500,
                ),
              )
            : ListView.builder(
                itemCount: cart.length,
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.white, // Background color for each ListTile
                    margin:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    padding: EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Image.asset(cart[index].imageUrl,
                          width: 70, height: 60),
                      title: Text(cart[index].title),
                      subtitle: Text(
                          'Quantity: ${cart[index].quantity} - Rs ${cart[index].price}'),
                      trailing: Text(
                          'Total: Rs ${(cart[index].price * cart[index].quantity).toStringAsFixed(2)}'),
                    ),
                  );
                },
              ),
      ),
      bottomNavigationBar: Container(
        color:
            Colors.grey[300], // Background color for the bottom navigation bar
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total: Rs ${totalPrice.toStringAsFixed(2)}'),
            ElevatedButton(
              onPressed: () => _checkout(context),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.orange, // Background color for the checkout button
              ),
              child: Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}
