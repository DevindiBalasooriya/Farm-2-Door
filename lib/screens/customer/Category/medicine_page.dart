import 'package:flutter/material.dart';
import 'package:my_app/model/customer_order_placement.dart';

import 'package:my_app/model/item.dart';
import 'package:my_app/model/itemUI.dart';
import 'package:my_app/screens/customer/cart_screen.dart';
import 'package:my_app/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnimalMedicinePage extends StatefulWidget {
  @override
  State<AnimalMedicinePage> createState() => _AnimalMedicinePageState();
}

class _AnimalMedicinePageState extends State<AnimalMedicinePage> {
  String? _email;
  String? _role;

  final DatabaseService _databaseService = DatabaseService();
  List<ItemUI> items = [
    ItemUI(
        id: "",
        imageUrl: 'assets/2.jpg', // Change this to your image path
        title: "Ganadexil",
        price: 100.00,
        quantity: 0,
        available: true),
    ItemUI(
        id: "",
        imageUrl: 'assets/3.jpg', // Change this to your image path
        title: "Chicktonic",
        price: 40.00,
        quantity: 0,
        available: false),
    ItemUI(
        id: "",
        imageUrl: 'assets/4.jpg', // Change this to your image path
        title: "Enterocare",
        price: 200.00,
        quantity: 0,
        available: true),
    ItemUI(
        id: "",
        imageUrl: 'assets/5.jpg', // Change this to your image path
        title: "Helmizole",
        price: 50.00,
        quantity: 0,
        available: true),
    ItemUI(
        id: "",
        imageUrl: 'assets/6.jpeg', // Change this to your image path
        title: " Vita-Stress",
        price: 100.00,
        quantity: 0,
        available: true),
  ];
  List<ItemUI> cart = [];

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
    _fetchOrders();
  }

  Future<void> _loadUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = prefs.getString('email');
      _role = prefs.getString('role');
    });
  }

  Future<void> _fetchOrders() async {
    String customerEmail = _email!;
    try {
      List<CustomerOrder> orders =
          (await _databaseService.getCustomerOrderByCustomerIdeAndCategory(
                  customerEmail, 'Medicine'))
              .cast<CustomerOrder>();
      setState(() {
        for (var order in orders) {
          var item = items.firstWhere((i) => i.title == order.itemName);
          item.quantity = order.quantity;
          item.id = order.id;
          cart.add(item);
        }
      });
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }

  void _addItemToCart(ItemUI item) async {
    item.quantity++;
    String orderId = '';
    if (item.id == "") {
      String customerEmail = _email!;
      CustomerOrder order = CustomerOrder(
        quantity: item.quantity,
        itemName: item.title,
        customerId: customerEmail,
        status: 'pending',
        onePrice: item.price.toInt(),
        totalPrice: item.quantity * item.price.toInt(),
      );
      CustomerOrder customerOrder =
          await _databaseService.addCustomerOrder(order);
      orderId = customerOrder.id!;
    } else {
      String customerEmail = _email!;
      String itemId = item.id!;
      CustomerOrder order = CustomerOrder(
        id: itemId,
        quantity: item.quantity,
        itemName: item.title,
        customerId: customerEmail,
        status: 'pending',
        onePrice: item.price.toInt(),
        totalPrice: item.quantity * item.price.toInt(),
      );
      orderId = itemId;
      await _databaseService.updateCustomerOrder(itemId, order);
    }
    try {
      setState(() {
        item.id = orderId;

        if (!cart.contains(item)) {
          cart.add(item);
        }
      });
    } catch (e) {
      print('Error adding order: $e');
    }
  }

  void _removeItemFromCart(ItemUI item) async {
    setState(() {
      if (item.quantity > 0) {
        item.quantity--;
      }
      if (item.quantity == 0) {
        cart.remove(item);
      }
    });

    if (item.quantity == 0) {
      try {
        if (item.id != "") {
          String itemId = item.id!;
          await _databaseService.deleteCustomerOrder(itemId);
        }
      } catch (e) {
        print('Error removing order: $e');
      }
    } else {
      String customerEmail = _email!;
      CustomerOrder order = CustomerOrder(
        id: item.id,
        quantity: item.quantity,
        itemName: item.title,
        customerId: customerEmail,
        status: 'pending',
        onePrice: item.price.toInt(),
        totalPrice: item.quantity * item.price.toInt(),
      );

      try {
        String orderId = order.id!;
        await _databaseService.updateCustomerOrder(orderId, order);
      } catch (e) {
        print('Error updating order: $e');
      }
    }
  }

  void _checkout() async {
    String customerEmail = _email!;
    try {
      for (var item in cart) {
        CustomerOrder order = CustomerOrder(
          id: item.id,
          quantity: item.quantity,
          itemName: item.title,
          customerId: customerEmail,
          status: 'ordered',
          onePrice: item.price.toInt(),
          totalPrice: item.quantity * item.price.toInt(),
        );
        String orderId = order.id!;
        await _databaseService.updateCustomerOrder(orderId, order);
      }
      setState(() {
        cart.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Checkout successful!')),
      );
    } catch (e) {
      print('Error during checkout: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during checkout: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animal Medicine'),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(cart: cart),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.black12,
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Container(
              color: index % 2 == 0 ? Colors.white : Colors.grey[400],
              margin: EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
              padding: EdgeInsets.all(1.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        item.imageUrl,
                        height: 140,
                        width: 155,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Rs ${item.price.toStringAsFixed(2)}",
                              style: TextStyle(
                                  color: Colors.brown[800],
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text(
                              item.available ? "In Stock" : "Out of stock",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:
                                    item.available ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          _removeItemFromCart(item);
                        },
                      ),
                      Text('${item.quantity}'),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          _addItemToCart(item);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.add_shopping_cart),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CartScreen(cart: cart),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
