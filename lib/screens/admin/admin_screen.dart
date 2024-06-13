import 'package:flutter/material.dart';
import 'package:my_app/screens/admin/add_item.dart';
import 'package:my_app/screens/admin/customer_list.dart';
import 'package:my_app/screens/admin/notifications.dart';
import 'package:my_app/screens/admin/placeorder.dart';
import 'package:my_app/screens/admin/store.dart';
import 'package:my_app/screens/admin/order_list.dart';
import 'package:my_app/screens/admin/owenr_list.dart';
import 'package:my_app/screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminDashboad extends StatefulWidget {
  const AdminDashboad({super.key});

  @override
  State<AdminDashboad> createState() => _AdminDashboardState();
}

class Category {
  final String name;
  final IconData icon;

  Category({required this.name, required this.icon});
}

class _AdminDashboardState extends State<AdminDashboad> {
  final List<Category> categories = [
    Category(name: 'Items', icon: Icons.list),
    Category(name: 'Store', icon: Icons.store),
    Category(name: 'Place Order', icon: Icons.shop),
    Category(name: 'Order List', icon: Icons.shopping_cart_checkout_sharp),
    Category(name: 'Notifications', icon: Icons.notifications),
    Category(name: 'Customer List', icon: Icons.person),
    Category(name: 'Farm owner List', icon: Icons.person),
  ];

  void navigateToCategoryPage(BuildContext context, String categoryName) {
    switch (categoryName) {
      case 'Items':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddItem()),
        );
        break;
      case 'Store':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ShopStore()),
        );
        break;
      case 'Place Order':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PlaceOrder()),
        );
        break;
      case 'Order List':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OrderList()),
        );
        break;
      case 'Notifications':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddNotificationScreen()),
        );
        break;
      case 'Customer List':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CustomerListPage()),
        );
        break;
      case 'Farm Owner List':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OwnerListPage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 238, 129, 4),
        title: Row(
          children: [
            ClipOval(
              child: Image.asset(
                'assets/b.png',
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Farm2Door',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        // Remove the back button
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            color: Colors.black,
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                print("Signed Out");
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SigninScreen()),
                );
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Color.fromRGBO(1, 39, 105, 1),
          Color.fromRGBO(1, 39, 105, 1),
          Colors.black
        ])),
        padding: const EdgeInsets.all(14.0),
        child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return GestureDetector(
              onTap: () {
                navigateToCategoryPage(context, category.name);
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 14.0),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 149, 190, 163),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Icon(
                        category.icon,
                        size: 50.0,
                        color: Color.fromARGB(255, 199, 221, 74),
                      ),
                      SizedBox(width: 40.0),
                      Text(
                        category.name,
                        style: TextStyle(color: Colors.black, fontSize: 22.0),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
