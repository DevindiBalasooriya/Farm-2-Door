import 'package:flutter/material.dart';

// Sample list to store notifications. Replace with your actual data source.
List<String> notifications = [];

class FarmOwnerNotificationScreen extends StatefulWidget {
  const FarmOwnerNotificationScreen({super.key});

  @override
  _FarmOwnerNotificationScreenState createState() =>
      _FarmOwnerNotificationScreenState();
}

class _FarmOwnerNotificationScreenState
    extends State<FarmOwnerNotificationScreen> {
  void _clearNotifications() {
    setState(() {
      notifications.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Notifications cleared successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Farm Owner Notifications'),
        actions: [
          IconButton(
            icon: Icon(Icons.clear_all),
            onPressed: _clearNotifications,
            tooltip: 'Clear Notifications',
          ),
        ],
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
        child: notifications.isEmpty
            ? Center(child: Text('No notifications available.'))
            : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(notifications[index]),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
