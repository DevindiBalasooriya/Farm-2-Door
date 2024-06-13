import 'package:flutter/material.dart';
import 'package:my_app/model/admin_order_placement.dart';
import 'package:my_app/model/customer_order.dart';
import 'package:my_app/model/farm_owner_item.dart';
import 'package:my_app/model/order.dart';
import 'package:my_app/model/user.dart';
import 'package:my_app/services/database_service.dart';

class PlaceOrder extends StatefulWidget {
  const PlaceOrder({super.key});

  @override
  State<PlaceOrder> createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  final DatabaseService dbService = DatabaseService();
  late Future<List<User>> _farmList;
  final _orderQuantityController = TextEditingController();
  String? _selectedFarmOwner;
  String? _selectedItem;
  Map<String, List<Map<String, dynamic>>> _farmOwnerItems = {};
  List<String> _farmOwners = [];
  List<Map<String, dynamic>>? _items;
  Map<String, dynamic>? _selectedItemDetails;

  @override
  void initState() {
    super.initState();
    _farmList = dbService.getUsersByRole("Farm owner");
    _loadFarmOwnersAndItems();
  }

  Future<void> _loadFarmOwnersAndItems() async {
    try {
      List<User> farmOwners = await _farmList;

      for (var farmOwner in farmOwners) {
        _farmOwners.add(farmOwner.userName);
        List<FarmOwnerItem?>? items = await _fetchItems(farmOwner.email);

        if (items != null) {
          List<Map<String, dynamic>> itemList = items
              .map((item) => {
                    'name': item?.itemName,
                    'quantity': item?.quantity,
                    'price': item?.price,
                    'farmerEmail': farmOwner.email,
                  })
              .toList();

          setState(() {
            _farmOwnerItems[farmOwner.userName] = itemList;
          });
        }
      }

      setState(() {
        _farmOwners = farmOwners.map((e) => e.userName).toList();
      });
    } catch (e) {
      print("Error loading farm owners and items: $e");
    }
  }

  Future<List<FarmOwnerItem>?> _fetchItems(String farmerEmail) async {
    try {
      List<FarmOwnerItem?> items =
          await dbService.getFarmOwnerItemsByFarmerName(farmerEmail);
      return items.whereType<FarmOwnerItem>().toList();
    } catch (e) {
      print("Error fetching items: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching items: $e')),
      );
      return null;
    }
  }

  void _orderItem() async {
    final quantity = int.tryParse(_orderQuantityController.text);
    if (quantity == null || quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid quantity')),
      );
      return;
    } // Convert price to double
    final price = (_selectedItemDetails!['price'] as num).toDouble();

    // Calculate total price
    final totalPrice = quantity * price;

    setState(() {
      _selectedItemDetails!['quantity'] -= quantity;
    });

    final order =
        Order(itemName: _selectedItemDetails!['name'], quantity: quantity);
    OrderRepository.instance.orders.add(order);
    AdminOrder newAdminOrder = AdminOrder(
        quantity: quantity,
        itemName: _selectedItemDetails!['name'],
        farmerEmail: _selectedItemDetails!['farmerEmail'],
        status: 'Ordered',
        totalPrice: totalPrice);

    await dbService.addAdminOrder(newAdminOrder);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order placed successfully')),
    );

    _orderQuantityController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Place Order'),
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
        ),
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            FutureBuilder<List<User>>(
              future: _farmList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No farm owners found');
                }
                return DropdownButtonFormField<String>(
                  hint: Text(
                    'Select Farm Owner',
                    style: TextStyle(color: Colors.blue),
                  ),
                  value: _selectedFarmOwner,
                  onChanged: (value) {
                    setState(() {
                      _selectedFarmOwner = value;
                      _items = _farmOwnerItems[value!];
                      _selectedItem = null;
                      _selectedItemDetails = null;
                    });
                  },
                  items: _farmOwners.map((String owner) {
                    return DropdownMenuItem<String>(
                      value: owner,
                      child: Text(
                        owner,
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(),
                  ),
                );
              },
            ),
            if (_selectedFarmOwner != null && _items != null)
              ..._items!.map((item) {
                return ListTile(
                  title: Text(
                    item['name'],
                    style: TextStyle(color: Colors.black),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quantity: ${item['quantity']}',
                        style: TextStyle(color: Colors.black),
                      ),
                      Text(
                        'Price: ${item['price']}',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                );
              }).toList(),
            SizedBox(height: 16.0),
            if (_selectedFarmOwner != null)
              Container(
                padding: EdgeInsets.all(8.0),
                color: Colors.white,
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      hint: Text(
                        'Select Item',
                        style: TextStyle(color: Colors.blue),
                      ),
                      value: _selectedItem,
                      onChanged: (value) {
                        setState(() {
                          _selectedItem = value;
                          _selectedItemDetails = _items!
                              .firstWhere((item) => item['name'] == value);
                        });
                      },
                      items: _items?.map((item) {
                        return DropdownMenuItem<String>(
                          value: item['name'],
                          child: Text(
                            item['name'],
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(),
                      ),
                    ),
                    if (_selectedItemDetails != null) ...[
                      Text(
                        'Item: ${_selectedItemDetails!['name']}',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      Text(
                        'Available Quantity: ${_selectedItemDetails!['quantity']}',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      TextField(
                        controller: _orderQuantityController,
                        decoration: InputDecoration(
                          labelText: 'Order Quantity',
                          labelStyle: TextStyle(color: Colors.blue),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: _orderItem,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: Text(
                          'Order',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _orderQuantityController.dispose();
    super.dispose();
  }
}
