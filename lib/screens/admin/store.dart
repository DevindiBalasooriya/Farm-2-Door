import 'package:flutter/material.dart';
import 'package:my_app/model/item.dart';
import 'package:my_app/services/database_service.dart';

class ShopStore extends StatefulWidget {
  const ShopStore({super.key});

  @override
  State<ShopStore> createState() => _ShopStoreState();
}

class _ShopStoreState extends State<ShopStore> {
  DatabaseService dbService = DatabaseService();
  final _searchController = TextEditingController();
  final _newPriceController = TextEditingController();
  final _quantityChangeController = TextEditingController();
  String? _selectedItem;
  String? _quantityChangeType = 'Increase';
  Map<String, Item> _items = {};
  List<Item> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    try {
      List<Item> items = await dbService.getAllItems();
      setState(() {
        _items = {for (var item in items) item.title: item};
      });
    } catch (e) {
      print("Error fetching items: $e");
    }
  }

  void _filterItems(String query) {
    if (query.isNotEmpty) {
      setState(() {
        _filteredItems = _items.values
            .where((item) =>
                item.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    } else {
      setState(() {
        _filteredItems = [];
      });
    }
  }

  void _selectItem(Item item) {
    setState(() {
      _selectedItem = item.title;
      _searchController.text = item.title;
      _selectedItemDetails = item.toJson();
      _filteredItems.clear();
    });
  }

  Map<String, dynamic>? _selectedItemDetails;

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
    Item updatedItem = Item(
      id: _selectedItemDetails!['id'],
      title: _selectedItemDetails!['title'],
      price: _selectedItemDetails!['price'],
      available: _selectedItemDetails!['available'],
      quantity: _selectedItemDetails!['quantity'],
      category: _selectedItemDetails!['category'],
    );
    await dbService.updateItem(_selectedItemDetails!['id'], updatedItem);
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
        title: Text('Shop Store Management'),
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
                      labelStyle:
                          TextStyle(color: Colors.blue), // Label text color
                      filled: true,
                      fillColor: Colors.white, // Text box background color
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(color: Colors.black), // Input text color
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
                      title: Text(item.title,
                          style: TextStyle(color: Colors.black)),
                      onTap: () => _selectItem(item),
                    );
                  },
                ),
              ),
            if (_selectedItemDetails != null) ...[
              Text(
                'Item: $_selectedItem',
                style:
                    TextStyle(fontSize: 16, color: Colors.black), // Text color
              ),
              Text(
                'Current Price: Rs ${_selectedItemDetails!['price']}',
                style:
                    TextStyle(fontSize: 16, color: Colors.black), // Text color
              ),
              Text(
                'Current Quantity: ${_selectedItemDetails!['quantity']}',
                style:
                    TextStyle(fontSize: 16, color: Colors.black), // Text color
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _newPriceController,
                decoration: InputDecoration(
                  labelText: 'New Price',
                  labelStyle: TextStyle(color: Colors.blue), // Label text color
                  filled: true,
                  fillColor: Colors.white, // Text box background color
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                style: TextStyle(color: Colors.black), // Input text color
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _quantityChangeController,
                decoration: InputDecoration(
                  labelText: 'Quantity Change',
                  labelStyle: TextStyle(color: Colors.blue), // Label text color
                  filled: true,
                  fillColor: Colors.white, // Text box background color
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.black), // Input text color
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
                    child: Text(type,
                        style: TextStyle(
                            color: Colors.black)), // Dropdown item text color
                  );
                }).toList(),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white, // Dropdown background color
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _updateItem,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // Button color
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
