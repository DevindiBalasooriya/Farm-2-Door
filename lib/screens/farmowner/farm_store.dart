import 'package:flutter/material.dart';
import 'package:my_app/model/farm_owner_item.dart';
import 'package:my_app/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FarmStore extends StatefulWidget {
  const FarmStore({Key? key}) : super(key: key);

  @override
  State<FarmStore> createState() => _FarmStoreState();
}

class _FarmStoreState extends State<FarmStore> {
  String? _email;
  String? _role;

  DatabaseService dbService = DatabaseService();
  final _searchController = TextEditingController();
  final _newPriceController = TextEditingController();
  final _quantityChangeController = TextEditingController();
  String? _selectedItem;
  String? _quantityChangeType = 'Increase';
  Map<String, FarmOwnerItem> _items = {};
  List<FarmOwnerItem> _filteredItems = [];
  Map<String, dynamic>? _selectedItemDetails;

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = prefs.getString('email');
      _role = prefs.getString('role');
    });
    if (_email != null) {
      _fetchItems();
    } else {
      // Handle the case where the email is not found
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No email found in shared preferences')),
      );
    }
  }

  Future<void> _fetchItems() async {
    if (_email == null) {
      return;
    }
    String farmerEmail = _email!;
    try {
      List<FarmOwnerItem?> items =
          await dbService.getFarmOwnerItemsByFarmerName(farmerEmail);

      // Filter out any null items and cast to List<FarmOwnerItem>
      List<FarmOwnerItem> nonNullItems =
          items.whereType<FarmOwnerItem>().toList();

      setState(() {
        _items = {for (var item in nonNullItems) item.itemName: item};
      });
    } catch (e) {
      print("Error fetching items: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching items: $e')),
      );
    }
  }

  void _filterItems(String query) {
    setState(() {
      _filteredItems = _items.values
          .where((item) =>
              item.itemName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _selectItem(FarmOwnerItem item) {
    setState(() {
      _selectedItem = item.itemName;
      _searchController.text = item.itemName;
      _selectedItemDetails = item.toJson();
      _filteredItems.clear();
    });
  }

  void _searchItem() {
    setState(() {
      _selectedItem = _searchController.text;
      _selectedItemDetails = _items[_selectedItem]?.toJson();

      if (_selectedItemDetails == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Item not found')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Item found')),
        );
      }
    });
  }

  Future<void> _updateItem() async {
    final newPrice = double.tryParse(_newPriceController.text);
    final quantityChange = int.tryParse(_quantityChangeController.text);
    if (newPrice == null || quantityChange == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter valid values')),
      );
      return;
    }
    setState(() {
      if (_selectedItemDetails != null) {
        _selectedItemDetails!['price'] = newPrice;
        if (_quantityChangeType == 'Increase') {
          _selectedItemDetails!['quantity'] += quantityChange;
        } else {
          _selectedItemDetails!['quantity'] -= quantityChange;
        }
      }
    });
    FarmOwnerItem updatedItem = FarmOwnerItem(
      id: _selectedItemDetails!['id'],
      itemName: _selectedItemDetails!['itemName'],
      price: _selectedItemDetails!['price'],
      available: _selectedItemDetails!['available'],
      quantity: _selectedItemDetails!['quantity'],
      category: _selectedItemDetails!['category'],
      farmerName: _selectedItemDetails!['farmerName'],
    );
    await dbService.updateFarmOwnerItem(
      _selectedItemDetails!['id'],
      updatedItem,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Item updated successfully')),
    );
    _newPriceController.clear();
    _quantityChangeController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Farm Store Management'),
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
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search Item Name',
                      labelStyle: TextStyle(color: Colors.blue),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(color: Colors.black),
                    onChanged: _filterItems,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  color: Colors.blue,
                  onPressed: _searchItem,
                ),
              ],
            ),
            if (_filteredItems.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = _filteredItems[index];
                    return ListTile(
                      title: Text(
                        item.itemName,
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () => _selectItem(item),
                    );
                  },
                ),
              ),
            if (_selectedItemDetails != null) ...[
              Text(
                'Item: $_selectedItem',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              Text(
                'Current Price: Rs ${_selectedItemDetails!['price']}',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              Text(
                'Current Quantity: ${_selectedItemDetails!['quantity']}',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _newPriceController,
                decoration: InputDecoration(
                  labelText: 'New Price',
                  labelStyle: TextStyle(color: Colors.blue),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _quantityChangeController,
                decoration: InputDecoration(
                  labelText: 'Quantity Change',
                  labelStyle: TextStyle(color: Colors.blue),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _quantityChangeType,
                onChanged: (value) {
                  setState(() {
                    _quantityChangeType = value;
                  });
                },
                items: ['Increase', 'Decrease'].map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(
                      type,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _updateItem,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                child: Text('Update'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _newPriceController.dispose();
    _quantityChangeController.dispose();
    super.dispose();
  }
}
