import 'package:flutter/material.dart';

class AddNotificationScreen extends StatefulWidget {
  const AddNotificationScreen({super.key});

  @override
  State<AddNotificationScreen> createState() => _AddNotificationScreenState();
}

class _AddNotificationScreenState extends State<AddNotificationScreen> {
  final TextEditingController _notificationController = TextEditingController();

  void _sendNotification() {
    String notification = _notificationController.text;
    if (notification.isNotEmpty) {
      // Logic to send notification to customers and farm owners
      sendNotificationToAll(notification);

      // Clear the text field
      _notificationController.clear();

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Notification sent successfully!')),
      );
    } else {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a notification message.')),
      );
    }
  }

  void sendNotificationToAll(String message) {
    // Logic to send notification to customers
    sendNotificationToCustomers(message);

    // Logic to send notification to farm owners
    sendNotificationToFarmOwners(message);
  }

  void sendNotificationToCustomers(String message) {
    // Implement the logic to send notification to all customers
    // For example, using Firebase Cloud Messaging (FCM)
    // FirebaseMessaging.instance.send(message);
  }

  void sendNotificationToFarmOwners(String message) {
    // Implement the logic to send notification to all farm owners
    // For example, using Firebase Cloud Messaging (FCM)
    // FirebaseMessaging.instance.send(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('New Notifications'),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 30),
              TextField(
                controller: _notificationController,
                decoration: InputDecoration(
                  labelText: 'Notification Content',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.black38,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(color: Colors.white),
                cursorColor: Colors.white,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _sendNotification,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 226, 221, 213),
                ),
                child: Text('Send Notification'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
