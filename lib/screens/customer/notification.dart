import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  final String notificationMessage;

  NotificationScreen({required this.notificationMessage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 87, 34),
        title: Text('Notifications'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            notificationMessage,
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
