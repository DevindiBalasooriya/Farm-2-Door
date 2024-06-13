import 'package:flutter/material.dart';
import 'package:my_app/screens/farmowner/add_farm_item.dart';
import 'package:my_app/screens/farmowner/farm_store.dart';
import 'package:my_app/screens/farmowner/notifications.dart';
import 'package:my_app/screens/farmowner/order_list.dart';
import 'package:my_app/screens/farmowner/owner_profile.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/screens/signin_screen.dart';
import 'package:my_app/services/notification_service.dart';

class FarmownerHomeScreen extends StatefulWidget {
  FarmownerHomeScreen({super.key});

  @override
  State<FarmownerHomeScreen> createState() => _FarmownerHomeScreenState();
}

class _FarmownerHomeScreenState extends State<FarmownerHomeScreen> {
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();

    notificationServices.requestNotificationPermisions();
    notificationServices.forgroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isRefreshToken();
    notificationServices.getDeviceToken().then((value) {
      print(value);
    });
  }

  final List<Category> categories = [
    Category(name: 'Farm Items', icon: Icons.store),
    Category(name: 'Farm Store', icon: Icons.list),
    Category(name: 'Order list', icon: Icons.agriculture),
    Category(name: 'Profile', icon: Icons.people),
  ];

  void navigateToCategoryPage(BuildContext context, String categoryName) {
    switch (categoryName) {
      case 'Farm Items':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddFarmItem()),
        );
        break;
      case 'Farm Store':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FarmStore()),
        );
        break;

      case 'Notificatons':
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FarmOwnerNotificationScreen()),
        );
        break;
      case 'Order List':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FarmOrderList()),
        );
        break;
      case 'Profile':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OwnerProfile()),
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
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About Us'),
              onTap: () {
                // Navigate to About Us page
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_mail),
              title: const Text('Contact'),
              onTap: () {
                // Navigate to Contact page
              },
            ),
            // Add more ListTiles as needed
          ],
        ),
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
                      SizedBox(width: 30.0),
                      Text(
                        category.name,
                        style: TextStyle(color: Colors.black, fontSize: 20.0),
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

class Category {
  final String name;
  final IconData icon;

  Category({required this.name, required this.icon});
}
