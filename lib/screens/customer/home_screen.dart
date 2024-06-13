import 'package:flutter/material.dart';
import 'package:my_app/services/notification_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  String notificationMessage = 'No new notifications';

  void updateNotification(String message) {
    setState(() {
      notificationMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.blueAccent,
            child: Text(
              notificationMessage,
              style: TextStyle(color: Colors.white),
            ),
          ),
          // Other widgets for your home screen can go here
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Simulating a new notification from admin
          updateNotification('New notification from admin!');
        },
        child: Icon(Icons.notification_add),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomeScreen(),
  ));
}
